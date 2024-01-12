---@class core.types.constants
GC = {}

---@class core.types.constants.priority
---@field signs { ['lsp'|'git']: integer }

---@class core.types.constants
---@field priority core.types.constants.priority
GC.priority = {
  signs = {
    -- starts at 16 to provide room for other plugins
    lsp = 16,
    git = 18,
  },
}
