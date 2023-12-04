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
  Text          = "Comment",
  Method        = "Constant",
  Function      = "Constant",
  Constructor   = "Structure",
  Field         = "Identifier",
  Variable      = "Identifier",
  Class         = "Structure",
  Interface     = "Structure",
  Module        = "Keyword",
  Property      = "Keyword",
  Unit          = "Constant",
  Value         = "Constant",
  Enum          = "Constant",
  Keyword       = "Keyword",
  Snippet       = "Comment",
  Color         = "Constant",
  File          = "Title",
  Reference     = "Identifier",
  Folder        = "Type",
  EnumMember    = "Constant",
  Constant      = "Constant",
  Struct        = "Structure",
  Event         = "Keyword",
  Operator      = "Operator",
  TypeParameter = "Type",
  Namespace     = "Constant",
  Table         = "Structure",
  Object        = "Structure",
  Tag           = "Identifier",
  Array         = "Type",
  Boolean       = "Boolean",
  Number        = "Constant",
  Null          = "Comment",
  String        = "Comment",
  Package       = "healthWarning",
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
