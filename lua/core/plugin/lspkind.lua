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
  Text = core.icons.text,
  Method = core.icons.method,
  Function = core.icons.fn,
  Constructor = core.icons.constructor,
  Field = core.icons.field,
  Variable = core.icons.variable,
  Class = core.icons.class,
  Interface = core.icons.interface,
  Module = core.icons.module,
  Property = core.icons.property,
  Unit = core.icons.unit,
  Value = core.icons.value,
  Enum = core.icons.enum,
  Keyword = core.icons.keyword,
  Snippet = core.icons.snippet,
  Color = core.icons.color,
  File = core.icons.file,
  Reference = core.icons.reference,
  Folder = core.icons.folder,
  EnumMember = core.icons.enummember,
  Constant = core.icons.constant,
  Struct = core.icons.struct,
  Event = core.icons.event,
  Operator = core.icons.operator,
  TypeParameter = core.icons.typeparameter,
  Namespace = core.icons.namespace,
  Table = core.icons.table,
  Object = core.icons.object,
  Tag = core.icons.tag,
  Array = core.icons.array,
  Boolean = core.icons.boolean,
  Number = core.icons.number,
  Null = core.icons.null,
  String = core.icons.string,
  Package = core.icons.package,
}

M.kind_icons = kind_icons

local kind_hl = {
  Text  = "Comment",
  Method  = "Constant",
  Function  = "Constant",
  Constructor  = "Structure",
  Field  = "Identifier",
  Variable  = "Identifier",
  Class  = "Structure",
  Interface  = "Structure",
  Module  = "Keyword",
  Property  = "Keyword",
  Unit  = "Constant",
  Value  = "Constant",
  Enum  = "Constant",
  Keyword  = "Keyword",
  Snippet  = "Comment",
  Color  = "Constant",
  File  = "Title",
  Reference  = "Identifier",
  Folder  = "Type",
  EnumMember  = "Constant",
  Constant  = "Constant",
  Struct  = "Structure",
  Event  = "Keyword",
  Operator  = "Operator",
  TypeParameter  = "Type",
  Namespace = "Constant",
  Table = "Structure",
  Object = "Structure",
  Tag = "Identifier",
  Array = "Type",
  Boolean = "Boolean",
  Number = "Constant",
  Null = "Comment",
  String = "Comment",
  Package = "healthWarning",
}

for kind, item in pairs(kind_hl) do
  local hi_group = string.format('CmpItemKind%s', kind)
  local hl = { link = item }
  vim.api.nvim_set_hl(0, hi_group, hl)
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
