local Util = require 'core.utils'

---@alias LspConfig__mappings 'show_lsp_info'|'goto_declaration'|'goto_definition'|'hover'|'goto_implementation'|'show_signature'|'show_type_definition'|'rename'|'show_code_action'|'goto_references'|'format'
---@alias LspConfig__servers { [string]: { settings: table, [string]: table } }

---@class LspConfigOpts
---@field mappings { [LspConfig__mappings]: string }
---@field config table
---@field servers LspConfig__servers

---@param servers LspConfig__servers
---@param capabilities table
local function setup_servers(servers, capabilities)
  -- patch lua lsp
  if servers.lua_ls then
    -- Make runtime files discoverable to the server
    local runtime_path = vim.split(package.path, ';')
    table.insert(runtime_path, 'lua/?.lua')
    table.insert(runtime_path, 'lua/?/init.lua')
    servers.lua_ls.settings = {
      Lua = {
        diagnostics = {
          -- recognize 'vim' global
          globals = { 'vim', 'table', 'package' }
        },
        workspace = {
          -- Make server aware of nvim runtime files
          library = vim.api.nvim_get_runtime_file("", true)
        },
        runtime = {
          -- Tell the language server which version of Lua you're using (most likely LuaJIT)
          version = 'LuaJIT',
          -- Setup your lua path
          path = runtime_path,
        },
        -- Do not send telemetry data containing a randomized but unique identifier
        telemetry = { enable = false },
      },
    }
  end

  local nvim_lsp = require 'lspconfig'

  for name, opts in pairs(servers) do
    if type(opts) == 'function' then
      opts = opts(nvim_lsp)
    end

    opts.capabilities = capabilities
    Util.log(string.format('setup_lsp:%s', name))
    nvim_lsp[name].setup(opts)
  end
end

return {
  ---@param opts LspConfigOpts
  setup = function(opts)
    keymaps.normal[opts.mappings.show_lsp_info] = { function()
      require 'lspconfig.ui.lspinfo' ()
    end, 'Show Lsp Info' }

    -- lsp diagnostics
    vim.diagnostic.config(opts.config)

    -- Global mappings.
    -- See `:help vim.diagnostic.*` for documentation on any of the below functions
    vim.keymap.set('n', '<space>e', vim.diagnostic.open_float)
    vim.keymap.set('n', '[d', vim.diagnostic.goto_prev)
    vim.keymap.set('n', ']d', vim.diagnostic.goto_next)
    vim.keymap.set('n', '<space>q', vim.diagnostic.setloclist)

    -- nvim-cmp supports additional completion capabilities
    local capabilities = vim.lsp.protocol.make_client_capabilities()
    capabilities = require 'cmp_nvim_lsp'.default_capabilities(capabilities)

    Util.log 'set up lsp servers'
    setup_servers(opts.servers, capabilities)

    -- Use LspAttach autocommand to only map the following keys
    -- after the language server attaches to the current buffer
    vim.api.nvim_create_autocmd('LspAttach', {
      group = vim.api.nvim_create_augroup('UserLspConfig', {}),
      callback = function(ev)
        Util.log('lsp server attached to current buffer', 'info')

        -- Enable completion triggered by <c-x><c-o>
        vim.bo[ev.buf].omnifunc = 'v:lua.vim.lsp.omnifunc'

        -- Buffer local mappings.
        -- See `:help vim.lsp.*` for documentation on any of the below functions
        local map_opts = { buffer = ev.buf }
        vim.keymap.set('n', opts.mappings.goto_declaration, vim.lsp.buf.declaration, map_opts)
        vim.keymap.set('n', opts.mappings.goto_definition, vim.lsp.buf.definition, map_opts)
        vim.keymap.set('n', opts.mappings.hover, vim.lsp.buf.hover, map_opts)
        vim.keymap.set('n', opts.mappings.goto_implementation, vim.lsp.buf.implementation, map_opts)
        vim.keymap.set({ 'n', 'i' }, opts.mappings.show_signature, vim.lsp.buf.signature_help, map_opts)
        vim.keymap.set('n', opts.mappings.show_type_definition, vim.lsp.buf.type_definition, map_opts)
        vim.keymap.set('n', opts.mappings.rename, vim.lsp.buf.rename, map_opts)
        vim.keymap.set({ 'n', 'v' }, opts.mappings.show_code_action, vim.lsp.buf.code_action, map_opts)
        vim.keymap.set('n', opts.mappings.goto_references, vim.lsp.buf.references, map_opts)
        vim.keymap.set('n', opts.mappings.format, function()
          vim.lsp.buf.format { async = true }
        end, map_opts)
      end,
    })
  end
}
