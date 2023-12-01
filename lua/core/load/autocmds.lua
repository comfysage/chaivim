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
    })
  end,
}
