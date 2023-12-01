local M = {}

local cmp_hi = {
  CmpItemMenu           = { fg = vim.api.nvim_get_hl_by_name('Constant', true)['foreground'], bg = "NONE", italic = true },

  CmpItemAbbrDeprecated = { link = "Comment" },

  CmpItemAbbrMatch      = { link = "Search" },
  CmpItemAbbrMatchFuzzy = { link = "CmpItemAbbrMatch" },
}

for hi_group, hl in pairs(cmp_hi) do
  vim.api.nvim_set_hl(0, hi_group, hl)
end

local kind_icons = {
  Text  = { "", "Comment" },
  Method  = { "", "Constant" },
  Function  = { "", "Constant" },
  Constructor  = { "", "Structure" },
  Field  = { "ﰠ", "Identifier" },
  Variable  = { "󰀫", "Identifier" },
  Class  = { "ﴯ", "Structure" },
  Interface  = { "", "Structure" },
  Module  = { "", "Keyword" },
  Property  = { "ﰠ", "Keyword" },
  Unit  = { "", "Constant" },
  Value  = { "", "Constant" },
  Enum  = { "", "Constant" },
  Keyword  = { "", "Keyword" },
  Snippet  = { "", "Comment" },
  Color  = { "", "Constant" },
  File  = { "", "Title" },
  Reference  = { "", "Identifier" },
  Folder  = { "", "Type" },
  EnumMember  = { "", "Constant" },
  Constant  = { "", "Constant" },
  Struct  = { "פּ", "Structure" },
  Event  = { "", "Keyword" },
  Operator  = { "", "Operator" },
  TypeParameter  = { "", "Type" },
  Namespace = "󰌗",
  Table = { "", "Structure" },
  Object = { "󰅩", "Structure" },
  Tag = { "", "Identifier" },
  Array = { "[]", "Type" },
  Boolean = { "", "Boolean" },
  Number = { "", "Constant" },
  Null = { "󰟢", "Comment" },
  String = { "\"\"", "Comment" },
  Package = { "", "healthWarning" },
}

for kind, item in pairs(kind_icons) do
  local hi_group = string.format('CmpItemKind%s', kind)
  local hl = { link = item[2] }
  vim.api.nvim_set_hl(0, hi_group, hl)
end

local max_count = 26

function M.format(entry, vim_item)
  -- Kind icons
  vim_item.kind = string.format('%s %s', kind_icons[vim_item.kind][1], vim_item.kind) -- This concatonates the icons with the name of the item kind
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
