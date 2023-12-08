#!/usr/bin/env bash

# adapted from @LunarVim https://github.com/LunarVim/LunarVim/blob/a45cfa5979ab38359d3284acd65214379ef8c2bc/utils/installer/install.sh

set -eo pipefail

OS="$(uname -s)"

declare -xr XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-"$HOME/.config"}"
declare -xr NVIM_APPNAME="${NVIM_APPNAME:-"cvim"}"
declare -xr CONFIG_DIR="${CONFIG_DIR:-"$XDG_CONFIG_HOME/$NVIM_APPNAME"}"

declare -xr INSTALL_PREFIX="${INSTALL_PREFIX:-"$HOME/.local"}"

function usage() {
  echo "Usage: install.sh [<options>]"
  echo ""
  echo "Options:"
  echo "    -h, --help                               Print this help message"
  echo "    -y, --yes                                Disable confirmation prompts (answer yes to all questions)"
  echo "    --overwrite                              Overwrite previous chaivim configuration (a backup is always performed first)"
}

function parse_arguments() {
  while [ "$#" -gt 0 ]; do
    case "$1" in
      --overwrite)
        ARGS_OVERWRITE=1
        ;;
      -y | --yes)
        INTERACTIVE_MODE=0
        ;;
      -h | --help)
        usage
        exit 0
        ;;
    esac
    shift
  done
}

function msg() {
  local text="$1"
  local div_width="80"
  printf "%${div_width}s\n" ' ' | tr ' ' -
  printf "%s\n" "$text"
}

function confirm() {
  local question="$1"
  while true; do
    msg "$question"
    read -p "[y]es or [n]o (default: no) : " -r answer
    case "$answer" in
      y | Y | yes | YES | Yes)
        return 0
        ;;
      n | N | no | NO | No | *[[:blank:]]* | "")
        return 1
        ;;
      *)
        msg "Please answer [y]es or [n]o."
        ;;
    esac
  done
}

function stringify_array() {
  echo -n "${@}" | sed 's/ /, /'
}

function main() {
  parse_arguments "$@"

  print_logo

  msg "Detecting platform for managing any additional neovim dependencies"
  detect_platform

  check_system_deps

  create_init

  setup_cvim

  msg "$ADDITIONAL_WARNINGS"
  echo "You can start it by running: $INSTALL_PREFIX/bin/$NVIM_APPNAME"
  echo "Do not forget to use a font with glyphs (icons) support [https://github.com/ryanoasis/nerd-fonts]"
}

function detect_platform() {
  case "$OS" in
    Linux)
      if [ -f "/etc/arch-release" ] || [ -f "/etc/artix-release" ]; then
        RECOMMEND_INSTALL="sudo pacman -S"
      elif [ -f "/etc/fedora-release" ] || [ -f "/etc/redhat-release" ]; then
        RECOMMEND_INSTALL="sudo dnf install -y"
      elif [ -f "/etc/gentoo-release" ]; then
        RECOMMEND_INSTALL="emerge -tv"
      else # assume debian based
        RECOMMEND_INSTALL="sudo apt install -y"
      fi
      ;;
    FreeBSD)
      RECOMMEND_INSTALL="sudo pkg install -y"
      ;;
    NetBSD)
      RECOMMEND_INSTALL="sudo pkgin install"
      ;;
    OpenBSD)
      RECOMMEND_INSTALL="doas pkg_add"
      ;;
    Darwin)
      RECOMMEND_INSTALL="brew install"
      ;;
    *)
      echo "OS $OS is not currently supported."
      exit 1
      ;;
  esac
}

function print_missing_dep_msg() {
  if [ "$#" -eq 1 ]; then
    echo "[ERROR]: Unable to find dependency [$1]"
    echo "Please install it first and re-run the installer. Try: $RECOMMEND_INSTALL $1"
  else
    local cmds
    cmds=$(for i in "$@"; do echo "$RECOMMEND_INSTALL $i"; done)
    printf "[ERROR]: Unable to find dependencies [%s]" "$@"
    printf "Please install any one of the dependencies and re-run the installer. Try: \n%s\n" "$cmds"
  fi
}

function check_neovim_min_version() {
  local verify_version_cmd='if !has("nvim-0.9") | cquit | else | quit | endif'

  # exit with an error if min_version not found
  if ! nvim --headless -u NONE -c "$verify_version_cmd"; then
    echo "[ERROR]: ChaiVim requires at least Neovim v0.9 or higher"
    exit 1
  fi
}

function validate_install_prefix() {
  local prefix="$1"
  case $PATH in
    *"$prefix/bin"*)
      return
      ;;
  esac
  local profile="$HOME/.profile"
  test -z "$ZSH_VERSION" && profile="$ZDOTDIR/.zshenv"
  ADDITIONAL_WARNINGS="[WARN] the folder $prefix/bin is not on PATH, consider adding 'export PATH=$prefix/bin:\$PATH' to your $profile"

  # avoid problems when calling any verify_* function
  export PATH="$prefix/bin:$PATH"
}

function check_system_deps() {
  validate_install_prefix "$INSTALL_PREFIX"

  if ! command -v git &>/dev/null; then
    print_missing_dep_msg "git"
    exit 1
  fi
  if ! command -v nvim &>/dev/null; then
    print_missing_dep_msg "neovim"
    exit 1
  fi
  check_neovim_min_version
}

function __backup_dir() {
  local src="$1"
  if [ ! -d "$src" ]; then
    return
  fi
  mkdir -p "$src.old"
  msg "Backing up old $src to $src.old"
  if command -v rsync &>/dev/null; then
    rsync --archive --quiet --backup --partial --copy-links --cvs-exclude "$src"/ "$src.old"
  else
    case "$OS" in
      Darwin)
        cp -R "$src/." "$src.old/."
        ;;
      *)
        cp -r "$src/." "$src.old/."
        ;;
    esac
  fi
}

function setup_shim() {
  binf="$INSTALL_PREFIX/bin/$NVIM_APPNAME"

  echo "\
#!/usr/bin/env bash
NVIM_APPNAME=$NVIM_APPNAME nvim \$@
" > "$binf"
}

function create_init() {
  [[ -d "$CONFIG_DIR" ]] && __backup_dir "$CONFIG_DIR"
  mkdir -p "$CONFIG_DIR"

  msg "creating init.lua"

  echo '
-- bootstrap chaivim
local rootpath = vim.fn.stdpath("data") .. "/core"
local chaipath = rootpath .. "/chai"

if not vim.loop.fs_stat(chaipath) then
  vim.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/crispybaccoon/chaivim.git",
    chaipath,
  }):wait()
end
vim.opt.rtp:prepend(chaipath)

require "core".setup "custom"
' > "$CONFIG_DIR/init.lua"

  mkdir -p "$CONFIG_DIR/lua/custom"
  echo 'return {
  colorscheme = "evergarden",
  transparent_background = false,
  modules = {
      core = {
          {
              "options",
              opts = {
                  cursorline = false,
                  tab_width = 2,
                  scrolloff = 5,
              },
          },
          {
              "dash",
              opts = {
                  open_on_startup = true,
              },
          },
      },
      custom = {
          -- your custom modules (in `lua/custom/`)
      },
  }
}
' > "$CONFIG_DIR/lua/custom/init.lua"
}

function setup_cvim() {
  msg "installing chaivim shim"

  setup_shim

  echo "preparing setup"

  "$INSTALL_PREFIX/bin/$NVIM_APPNAME" --headless -c 'quitall'

  printf "\nsetup complete"
}

function print_logo() {
  cat <<'EOF'
      __        _      _     
 ____/ /  ___ _(_)  __(_)_ _ 
/ __/ _ \/ _ `/ / |/ / /  ' \
\__/_//_/\_,_/_/|___/_/_/_/_/
                             
EOF
}

main "$@"
