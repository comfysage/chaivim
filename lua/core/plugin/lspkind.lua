local M = {}

local cmp_hi = {
  CmpItemMenu           = { fg = core.lib.hl.syntax.constant.fg, bg = "NONE", italic = true },

  CmpItemAbbrDeprecated = { fg = core.lib.hl.diagnostic.warn.fg },

  CmpItemAbbrMatch      = { fg = core.lib.hl.ui.match.fg },
  CmpItemAbbrMatchFuzzy = { link = "CmpItemAbbrMatch" },
}

for hi_group, hl in pairs(cmp_hi) do
  vim.api.nvim_set_hl(0, hi_group, hl)
end

local kind_icons = {
  Text = core.icons.syntax.text,
  Method = core.icons.syntax.method,
  Function = core.icons.syntax.fn,
  Constructor = core.icons.syntax.constructor,
  Field = core.icons.syntax.field,
  Variable = core.icons.syntax.variable,
  Class = core.icons.syntax.class,
  Interface = core.icons.syntax.interface,
  Module = core.icons.syntax.module,
  Property = core.icons.syntax.property,
  Unit = core.icons.syntax.unit,
  Value = core.icons.syntax.value,
  Enum = core.icons.syntax.enum,
  Keyword = core.icons.syntax.keyword,
  Snippet = core.icons.syntax.snippet,
  Color = core.icons.syntax.color,
  File = core.icons.syntax.file,
  Reference = core.icons.syntax.reference,
  Folder = core.icons.syntax.folder,
  EnumMember = core.icons.syntax.enummember,
  Constant = core.icons.syntax.constant,
  Struct = core.icons.syntax.struct,
  Event = core.icons.syntax.event,
  Operator = core.icons.syntax.operator,
  TypeParameter = core.icons.syntax.typeparameter,
  Namespace = core.icons.syntax.namespace,
  Table = core.icons.syntax.table,
  Object = core.icons.syntax.object,
  Tag = core.icons.syntax.tag,
  Array = core.icons.syntax.array,
  Boolean = core.icons.syntax.boolean,
  Number = core.icons.syntax.number,
  Null = core.icons.syntax.null,
  String = core.icons.syntax.string,
  Package = core.icons.syntax.package,
}

M.kind_icons = kind_icons

local kind_hl = {
  Text          = core.lib.hl.syntax.text,
  Method        = core.lib.hl.syntax.method,
  Function      = core.lib.hl.syntax.fn,
  Constructor   = core.lib.hl.syntax.constructor,
  Field         = core.lib.hl.syntax.field,
  Variable      = core.lib.hl.syntax.variable,
  Class         = core.lib.hl.syntax.class,
  Interface     = core.lib.hl.syntax.interface,
  Module        = core.lib.hl.syntax.module,
  Property      = core.lib.hl.syntax.property,
  Unit          = core.lib.hl.syntax.unit,
  Value         = core.lib.hl.syntax.value,
  Enum          = core.lib.hl.syntax.enum,
  Keyword       = core.lib.hl.syntax.keyword,
  Snippet       = core.lib.hl.syntax.snippet,
  Color         = core.lib.hl.syntax.color,
  File          = core.lib.hl.syntax.file,
  Reference     = core.lib.hl.syntax.reference,
  Folder        = core.lib.hl.syntax.folder,
  EnumMember    = core.lib.hl.syntax.enummember,
  Constant      = core.lib.hl.syntax.constant,
  Struct        = core.lib.hl.syntax.struct,
  Event         = core.lib.hl.syntax.event,
  Operator      = core.lib.hl.syntax.operator,
  TypeParameter = core.lib.hl.syntax.typeparameter,
  Namespace     = core.lib.hl.syntax.namespace,
  Table         = core.lib.hl.syntax.table,
  Object        = core.lib.hl.syntax.object,
  Tag           = core.lib.hl.syntax.tag,
  Array         = core.lib.hl.syntax.array,
  Boolean       = core.lib.hl.syntax.boolean,
  Number        = core.lib.hl.syntax.number,
  Null          = core.lib.hl.syntax.null,
  String        = core.lib.hl.syntax.string,
  Package       = core.lib.hl.syntax.package,
}

for kind, item in pairs(kind_hl) do
  local hi_group = string.format('CmpItemKind%s', kind)
  core.lib.highlight.apply {
    [hi_group] = item,
  }
end

local max_count = 26

function M.format(entry, vim_item)
  -- Kind icons
  vim_item.kind = string.format('%s %s', kind_icons[vim_item.kind], vim_item.kind) -- This concatonates the icons with the name of the item kind
  -- Source
  local menu_item = ({
    buffer = "Buffer",
    nvim_lsp = "LSP",
    luasnip = "LuaSnip",
    nvim_lua = "Lua",
    latex_symbols = "LaTeX",
  })[entry.source.name]
  vim_item.menu = menu_item and string.format('  (%s)', menu_item) or ''

  local word = vim_item.abbr
  vim_item.abbr = #word < max_count and word or string.sub(word, 0, max_count - 5) .. '...'
  return vim_item
end

return M
