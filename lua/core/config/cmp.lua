local Util = require 'core.utils'

return {
  add_sources = function()
    local sources = {
      'hrsh7th/cmp-nvim-lsp',
      'hrsh7th/cmp-nvim-lua',
      'hrsh7th/cmp-buffer',
      'hrsh7th/cmp-path',
      'hrsh7th/cmp-cmdline'
    }
    for _, url in ipairs(sources) do
      local _url = vim.split(url, '/')
      if #_url < 2 then
        goto continue
      end
      Util.add_to_path(_url[2])
      ::continue::
    end
  end,
  setup = function(opts)
    vim.g.indentLine_conceallevel = 2
    vim.g.indentLine_concealcursor = "inc"

    require 'core.bootstrap'.boot 'cmp'

    local ok, cmp = SR_L 'cmp'
    if not ok then
      return
    end

    -- local status, result = pcall(require, 'config.plugin.cmp-emoji')
    -- if not status then
    --   vim.notify('error while loading module:\n\t' .. result, vim.log.levels.ERROR)
    --   return
    -- end

    local snippet_fn = {
      vsnip = function(args) vim.fn["vsnip#anonymous"](args.body) end,
      luasnip = function(args) require('luasnip').lsp_expand(args.body) end,
      snippy = function(args) require('snippy').expand_snippet(args.body) end,
      ultisnips = function(args) vim.fn["UltiSnips#Anon"](args.body) end,
    }
    if snippet_fn[opts.snippet_engine] then
      opts.config.snippet.expand = snippet_fn[opts.snippet_engine]
    end

    ---@diagnostic disable-next-line redefined-local
    local ok, lspkind = SR_L 'core.plugin.lspkind'
    if ok then
      opts.config.formatting = {
        fields = { 'abbr', 'kind', 'menu' },
        format = lspkind.format,
      }
    end

    opts.config.sources = cmp.config.sources({
      { name = 'nvim_lua' },
      { name = 'nvim_lsp' },
      { name = opts.snippet_engine, max_item_count = 4 },
    }, {
      { name = 'path',    max_item_count = 5 },
      { name = 'cmdline', max_item_count = 5 },
      { name = 'buffer',  max_item_count = 5 },
    })

    keymaps.insert[opts.mappings.docs_down] = { cmp.mapping.scroll_docs(-4), '', group = 'cmp' }
    keymaps.insert[opts.mappings.docs_up] = { cmp.mapping.scroll_docs(4), '', group = 'cmp' }
    keymaps.insert[opts.mappings.complete] = { cmp.mapping.complete(), '', group = 'cmp' }
    keymaps.insert[opts.mappings.close] = cmp.mapping.abort()
    vim.keymap.set('c', opts.mappings.close, cmp.mapping.close(), { silent = true, noremap = true })

    if opts.completion_style == 'tab' then
      keymaps.insert['<Tab>'] = { cmp.mapping.confirm({ select = true }), '', group = 'cmp' }
      keymaps.insert['<Down>'] = { cmp.mapping.select_next_item(), '', group = 'cmp' }
      keymaps.insert['<Up>'] = { cmp.mapping.select_prev_item(), '', group = 'cmp' }
    end
    if opts.completion_style == 'enter' then
      keymaps.insert['<CR>'] = { cmp.mapping.confirm({ select = true }), '', group = 'cmp' }
      keymaps.insert['<Tab>'] = { cmp.mapping.select_next_item(), '', group = 'cmp' }
      keymaps.insert['<S-Tab>'] = { cmp.mapping.select_prev_item(), '', group = 'cmp' }
    end

    cmp.setup(opts.config)

    -- Set configuration for specific filetype.
    cmp.setup.filetype('gitcommit', {
      sources = cmp.config.sources({
        -- { name = 'cmp_git' }, -- You can specify the `cmp_git` source if you installed it.
      }, {
        { name = 'buffer' },
      })
    })

    cmp.setup.filetype('markdown', {
      sources = cmp.config.sources({
        { name = 'luasnip', max_item_count = 4 },
        -- { name = 'emoji' },
      }, {
        { name = "dictionary", keyword_length = 2, },
        { name = 'path' },
        { name = 'buffer',     max_item_count = 5 },
      })
    })

    -- Use buffer source for `/`
    cmp.setup.cmdline('/', {
      view = { entries = 'wildmenu' },
      sources = {
        { name = 'buffer' }
      }
    })

    -- Use cmdline & path source for ':'
    cmp.setup.cmdline(':', {
      sources = cmp.config.sources({
        { name = 'path' }
      }, {
        { name = 'cmdline' }
      })
    })
  end
}
