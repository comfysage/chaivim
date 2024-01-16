local M = {}

local cmp_hi = {
  CmpItemMenu           = { fg = core.lib.hl:get('syntax', 'constant'), bg = "none", italic = true },

  CmpItemAbbrDeprecated = { fg = core.lib.hl:get('diagnostic', 'warn') },

  CmpItemAbbrMatch      = { fg = core.lib.hl:get('ui', 'match') },
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
  Text          = core.lib.hl:get('syntax', 'text'),
  Method        = core.lib.hl:get('syntax', 'method'),
  Function      = core.lib.hl:get('syntax', 'fn'),
  Constructor   = core.lib.hl:get('syntax', 'constructor'),
  Field         = core.lib.hl:get('syntax', 'field'),
  Variable      = core.lib.hl:get('syntax', 'variable'),
  Class         = core.lib.hl:get('syntax', 'class'),
  Interface     = core.lib.hl:get('syntax', 'interface'),
  Module        = core.lib.hl:get('syntax', 'module'),
  Property      = core.lib.hl:get('syntax', 'property'),
  Unit          = core.lib.hl:get('syntax', 'unit'),
  Value         = core.lib.hl:get('syntax', 'value'),
  Enum          = core.lib.hl:get('syntax', 'enum'),
  Keyword       = core.lib.hl:get('syntax', 'keyword'),
  Snippet       = core.lib.hl:get('syntax', 'snippet'),
  Color         = core.lib.hl:get('syntax', 'color'),
  File          = core.lib.hl:get('syntax', 'file'),
  Reference     = core.lib.hl:get('syntax', 'reference'),
  Folder        = core.lib.hl:get('syntax', 'folder'),
  EnumMember    = core.lib.hl:get('syntax', 'enummember'),
  Constant      = core.lib.hl:get('syntax', 'constant'),
  Struct        = core.lib.hl:get('syntax', 'struct'),
  Event         = core.lib.hl:get('syntax', 'event'),
  Operator      = core.lib.hl:get('syntax', 'operator'),
  TypeParameter = core.lib.hl:get('syntax', 'typeparameter'),
  Namespace     = core.lib.hl:get('syntax', 'namespace'),
  Table         = core.lib.hl:get('syntax', 'table'),
  Object        = core.lib.hl:get('syntax', 'object'),
  Tag           = core.lib.hl:get('syntax', 'tag'),
  Array         = core.lib.hl:get('syntax', 'array'),
  Boolean       = core.lib.hl:get('syntax', 'boolean'),
  Number        = core.lib.hl:get('syntax', 'number'),
  Null          = core.lib.hl:get('syntax', 'null'),
  String        = core.lib.hl:get('syntax', 'string'),
  Package       = core.lib.hl:get('syntax', 'package'),
}

for kind, item in pairs(kind_hl) do
  local hi_group = string.format('CmpItemKind%s', kind)
  core.lib.hl.apply {
    [hi_group] = { fg = item },
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
