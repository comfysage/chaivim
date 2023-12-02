local parts = require 'core.parts'

return {
  setup = function(opts)
    vim.api.nvim_create_autocmd('BufWritePost', {
      -- command = 'source <afile>',
      callback = function(props)
        vim.notify('reloading module: ' .. CONFIG_MODULE .. '\t' .. props.file, vim.log.levels.INFO)
        vim.cmd.source(props.file)
      end,
      group = opts.group_id,
      pattern = 'lua/' .. CONFIG_MODULE .. '/init.lua',
      desc = 'config:reload:' .. CONFIG_MODULE,
    })
  end,
  ---@param spec ModuleSpec
  create_reload = function (module, spec)
    local file_name = string.gsub(module, '[.]', '/')
    vim.api.nvim_create_autocmd('BufWritePost', {
      callback = function (props)
        vim.notify('reloading module: ' .. module .. '\t' .. props.file, vim.log.levels.INFO)
        package.loaded[module] = nil
        parts.load(module, spec)
      end,
      group = core.group_id,
      pattern = 'lua/' .. file_name .. '.lua',
      desc = 'config:reload:' .. module,
    })
  end,
}
