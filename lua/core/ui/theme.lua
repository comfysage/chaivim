local Util = require 'core.utils'

return {
  ---@param theme core.types.lib.hl.table
  ---@param config table
  create = function(theme, config)
    local hl_groups = {}
    hl_groups.main = {}
    hl_groups.ui = {
      Normal = { theme.ui.fg, theme.ui.bg },
      FloatTitle = { theme.ui.bg, theme.ui.accent },

      Cursor = { theme.ui.fg },
      Visual = { 'none', theme.ui.bg3 },

      CursorLine = { 'none', theme.ui.current },
      CursorColumn = { 'none', theme.ui.bg1 },
      QuickFixLine = { 'none', theme.ui.bg1 },

      LineNr = { theme.ui.bg4 },
      CursorLineNr = { theme.ui.yellow, theme.ui.bg_accent },
      SignColumn = { 'none', theme.ui.bg_accent },
      WinSeparator = { theme.ui.border },
      VertSplit = { link = 'WinSeparator' },
      TabLineSel = { theme.ui.bg, theme.ui.accent },
      TabLine = { theme.ui.grey0 },
      TabLineFill = { link = 'TabLine' },
      Title = { theme.ui.comment },
      NonText = { theme.ui.bg2, 'none' },
      Folded = { theme.ui.comment },
      FoldColumn = { theme.ui.bg1 },

      NormalFloat = { theme.ui.fg, theme.ui.bg },
      FloatBorder = { theme.ui.border },
      StatusLine = { theme.ui.comment, theme.ui.bg_accent },
      StatusLineNC = { theme.ui.comment, theme.ui.bg_accent },
      FloatShadow = { 'none', 'none' },
      FloatShadowThrough = { 'none', 'none' },

      OkText = { theme.diagnostic.ok, 'none' },
      ErrorText = { theme.diagnostic.error, 'none' },
      WarningText = { theme.diagnostic.warn, 'none' },
      InfoText = { theme.diagnostic.info, 'none' },
      HintText = { theme.diagnostic.hint, 'none' },
      OkFloat = { theme.diagnostic.ok, theme.ui.bg_accent },
      ErrorFloat = { theme.diagnostic.error, theme.ui.bg_accent },
      WarningFloat = { theme.diagnostic.warn, theme.ui.bg_accent },
      InfoFloat = { theme.diagnostic.info, theme.ui.bg_accent },
      HintFloat = { theme.diagnostic.hint, theme.ui.bg_accent },

      Question = { theme.ui.comment },

      Search = { theme.ui.match, reverse = config.search.reverse },
      IncSearch = { theme.ui.focus, reverse = config.inc_search.reverse },

      Error = { theme.diagnostic.error },
      ErrorMsg = { link = 'Error' },
      WarningMsg = { theme.diagnostic.warn },
      MoreMsg = { theme.ui.comment },
      ModeMsg = { theme.ui.bg2, 'none' },

      ColorColumn = { 'none', theme.ui.bg1 },

      Todo = { theme.ui.bg, theme.ui.purple },

      Conceal = { theme.ui.bg3 },

      Directory = { theme.ui.folder_bg },

      -- Completion Menu
      Pmenu = { theme.ui.grey1, theme.ui.bg2 },
      PmenuSel = {
        theme.ui.bg2,
        theme.ui.pmenu_bg,
        reverse = config.search.reverse,
      },
      PmenuSbar = { 'none', theme.ui.bg2 },
      PmenuThumb = { 'none', theme.ui.grey1 },

      -- Diagnostics
      DiagnosticFloatingError = { link = 'ErrorFloat' },
      DiagnosticFloatingWarn = { link = 'WarningFloat' },
      DiagnosticFloatingInfo = { link = 'InfoFloat' },
      DiagnosticFloatingHint = { link = 'HintFloat' },
      DiagnosticFloatingOk = { link = 'OkFloat' },
      DiagnosticOk = { theme.diagnostic.ok },
      DiagnosticError = { theme.diagnostic.error },
      DiagnosticWarn = { theme.diagnostic.warn },
      DiagnosticInfo = { theme.diagnostic.info },
      DiagnosticHint = { theme.diagnostic.hint },
      DiagnosticVirtualTextError = { link = 'DiagnosticError' },
      DiagnosticVirtualTextWarn = { link = 'DiagnosticWarn' },
      DiagnosticVirtualTextInfo = { link = 'DiagnosticInfo' },
      DiagnosticVirtualTextHint = { link = 'DiagnosticHint' },
      DiagnosticUnderlineOk = {
        theme.diagnostic.ok,
        'none',
        underline = true,
      },
      DiagnosticUnderlineError = {
        theme.diagnostic.error,
        'none',
        underline = true,
      },
      DiagnosticUnderlineWarn = {
        theme.diagnostic.warn,
        'none',
        underline = true,
      },
      DiagnosticUnderlineInfo = {
        theme.diagnostic.info,
        'none',
        underline = true,
      },
      DiagnosticUnderlineHint = {
        theme.diagnostic.hint,
        'none',
        underline = true,
      },
      DiagnosticSignOk = { theme.diagnostic.ok, theme.ui.bg_accent },
      DiagnosticSignError = { theme.diagnostic.error, theme.ui.bg_accent },
      DiagnosticSignWarn = { theme.diagnostic.warn, theme.ui.bg_accent },
      DiagnosticSignInfo = { theme.diagnostic.info, theme.ui.bg_accent },
      DiagnosticSignHint = { theme.diagnostic.hint, theme.ui.bg_accent },
      LspDiagnosticsFloatingError = { link = 'DiagnosticFloatingError' },
      LspDiagnosticsFloatingWarning = { link = 'DiagnosticFloatingWarn' },
      LspDiagnosticsFloatingInformation = { link = 'DiagnosticFloatingInfo' },
      LspDiagnosticsFloatingHint = { link = 'DiagnosticFloatingHint' },
      LspDiagnosticsDefaultError = { link = 'DiagnosticError' },
      LspDiagnosticsDefaultWarning = { link = 'DiagnosticWarn' },
      LspDiagnosticsDefaultInformation = { link = 'DiagnosticInfo' },
      LspDiagnosticsDefaultHint = { link = 'DiagnosticHint' },
      LspDiagnosticsVirtualTextError = { link = 'DiagnosticVirtualTextError' },
      LspDiagnosticsVirtualTextWarning = { link = 'DiagnosticVirtualTextWarn' },
      LspDiagnosticsVirtualTextInformation = {
        link = 'DiagnosticVirtualTextInfo',
      },
      LspDiagnosticsVirtualTextHint = { link = 'DiagnosticVirtualTextHint' },
      LspDiagnosticsUnderlineError = { link = 'DiagnosticUnderlineError' },
      LspDiagnosticsUnderlineWarning = { link = 'DiagnosticUnderlineWarn' },
      LspDiagnosticsUnderlineInformation = { link = 'DiagnosticUnderlineInfo' },
      LspDiagnosticsUnderlineHint = { link = 'DiagnosticUnderlineHint' },
      LspDiagnosticsSignError = { link = 'DiagnosticSignError' },
      LspDiagnosticsSignWarning = { link = 'DiagnosticSignWarn' },
      LspDiagnosticsSignInformation = { link = 'DiagnosticSignInfo' },
      LspDiagnosticsSignHint = { link = 'DiagnosticSignHint' },
      LspReferenceText = { link = 'CurrentWord' },
      LspReferenceRead = { link = 'CurrentWord' },
      LspReferenceWrite = { link = 'CurrentWord' },
      LspCodeLens = { link = 'VirtualTextInfo' },
      LspCodeLensSeparator = { link = 'VirtualTextHint' },
      LspSignatureActiveParameter = { link = 'Search' },
      healthError = { link = 'DiagnosticError' },
      healthSuccess = { link = 'DiagnosticOk' },
      healthWarning = { link = 'DiagnosticWarn' },
      DiagnosticDeprecated = {
        theme.diagnostic.warn,
        'none',
        strikethrough = true,
      },
    }
    hl_groups.syntax = {
      Statement = { theme.syntax.keyword },
      Keyword = { theme.syntax.keyword, italic = config.keyword.italic },
      Identifier = { theme.syntax.identifier },
      Type = { theme.syntax.type, italic = config.types.italic },
      Function = { theme.syntax.fn },
      Structure = { theme.syntax.type },

      Comment = { theme.ui.comment, italic = config.comment.italic },

      Special = { theme.syntax.special },
      Delimiter = { link = 'Special' },
      Operator = { theme.syntax.operator },
      MatchParen = { theme.ui.orange },

      Constant = { theme.syntax.constant },
      String = { theme.syntax.string },

      PreProc = { theme.syntax.snippet },
      Include = { theme.syntax.snippet },

      Underlined = { 'none', 'none', underline = true },

      -- Treesitter
      TSStrong = { 'none', 'none', bold = true },
      TSEmphasis = { 'none', 'none', italic = true },
      TSUnderline = { 'none', 'none', underline = true },

      TSAnnotation = { theme.ui.purple },
      TSAttribute = { theme.ui.purple },
      TSBoolean = { link = 'Boolean' },
      TSCharacter = { link = 'Character' },
      TSComment = { link = 'Comment' },
      TSConditional = { link = 'Conditional' },
      TSConstBuiltin = { link = 'Constant' },
      TSConstMacro = { link = 'Constant' },
      TSConstant = { link = 'Constant' },
      TSConstructor = { theme.ui.green },
      TSException = { link = 'Exception' },
      TSField = { theme.syntax.field },
      TSFloat = { link = 'Float' },
      TSFuncBuiltin = { link = 'Constant' },
      TSFuncMacro = { theme.syntax.snippet },
      TSFunction = { link = 'Function' },
      TSInclude = { link = 'Include' },
      TSKeyword = { link = 'Keyword' },
      TSKeywordFunction = { link = 'Keyword' },
      TSKeywordOperator = { theme.syntax.snippet },
      TSLabel = { link = 'Label' },
      TSMethod = { theme.syntax.fn },
      TSNamespace = { link = 'Constant' },
      TSNone = { link = 'Normal' },
      TSNumber = { link = 'Number' },
      TSOperator = { link = 'Operator' },
      TSParameter = { link = 'Identifier' },
      TSParameterReference = { link = 'TSParameter' },
      TSProperty = { theme.syntax.object },
      TSPunctBracket = { link = 'Delimiter' },
      TSPunctDelimiter = { link = 'Delimiter' },
      TSPunctSpecial = { link = 'Special' },
      TSRepeat = { link = 'Repeat' },
      TSStorageClass = { link = 'StorageClass' },
      TSString = { link = 'String' },
      TSStringEscape = { theme.ui.yellow },
      TSStringRegex = { theme.ui.yellow },
      TSSymbol = { theme.ui.grey0 },
      TSTag = { link = 'Tag' },
      TSTagDelimiter = { theme.ui.grey0 },
      TSText = { theme.ui.grey0 },
      TSStrike = { theme.ui.grey1 },
      TSMath = { theme.ui.blue },
      TSType = { link = 'Type' },
      TSTypeBuiltin = { link = 'Type' },
      TSURI = { link = 'markdownUrl' },
      TSVariable = { link = 'Identifier' },
      TSVariableBuiltin = { link = 'Constant' },

      -- Diffs
      DiffAdd = { theme.diff.add, theme.ui.bg },
      DiffDelete = { theme.diff.delete, theme.ui.bg },
      DiffChange = { theme.diff.change, theme.ui.bg },
      DiffText = { theme.ui.fg, theme.ui.bg },
      diffAdded = { theme.diff.add },
      diffRemoved = { theme.diff.delete },
      diffChanged = { theme.diff.change },
      diffFile = { theme.syntax.object },
      diffNewFile = { theme.syntax.object },
      diffLine = { theme.ui.fg },

      -- Spell
      SpellCap = { theme.ui.green },
      SpellBad = { theme.ui.teal },
      SpellLocal = { theme.ui.teal },
      SpellRare = { theme.ui.purple },
    }

    hl_groups.syntax['@annotation'] = { link = 'TSAnnotation' }
    hl_groups.syntax['@attribute'] = { link = 'TSAttribute' }
    hl_groups.syntax['@boolean'] = { link = 'TSBoolean' }
    hl_groups.syntax['@character'] = { link = 'TSCharacter' }
    hl_groups.syntax['@comment'] = { link = 'TSComment' }
    hl_groups.syntax['@conditional'] = { link = 'TSConditional' }
    hl_groups.syntax['@constant'] = { link = 'TSConstant' }
    hl_groups.syntax['@constant.builtin'] = { link = 'TSConstBuiltin' }
    hl_groups.syntax['@constant.macro'] = { link = 'TSConstMacro' }
    hl_groups.syntax['@constructor'] = { link = 'TSConstructor' }
    hl_groups.syntax['@exception'] = { link = 'TSException' }
    hl_groups.syntax['@field'] = { link = 'TSField' }
    hl_groups.syntax['@float'] = { link = 'TSFloat' }
    hl_groups.syntax['@function'] = { link = 'TSFunction' }
    hl_groups.syntax['@function.call'] = { link = 'TSFunction' }
    hl_groups.syntax['@function.builtin'] = { link = 'TSFuncBuiltin' }
    hl_groups.syntax['@function.macro'] = { link = 'TSFuncMacro' }
    hl_groups.syntax['@include'] = { link = 'TSInclude' }
    hl_groups.syntax['@keyword'] = { link = 'TSKeyword' }
    hl_groups.syntax['@keyword.function'] = { link = 'TSKeywordFunction' }
    hl_groups.syntax['@keyword.operator'] = { link = 'TSKeywordOperator' }
    hl_groups.syntax['@label'] = { link = 'TSLabel' }
    hl_groups.syntax['@method'] = { link = 'TSMethod' }
    hl_groups.syntax['@method.call'] = { link = '@function.call' }
    hl_groups.syntax['@namespace'] = { link = 'TSNamespace' }
    hl_groups.syntax['@none'] = { link = 'TSNone' }
    hl_groups.syntax['@number'] = { link = 'TSNumber' }
    hl_groups.syntax['@operator'] = { link = 'TSOperator' }
    hl_groups.syntax['@parameter'] = { link = 'TSParameter' }
    hl_groups.syntax['@parameter.reference'] = { link = 'TSParameterReference' }
    hl_groups.syntax['@property'] = { link = 'TSProperty' }
    hl_groups.syntax['@punctuation.bracket'] = { link = 'TSPunctBracket' }
    hl_groups.syntax['@punctuation.delimiter'] = { link = 'TSPunctDelimiter' }
    hl_groups.syntax['@punctuation.special'] = { link = 'TSPunctSpecial' }
    hl_groups.syntax['@repeat'] = { link = 'TSRepeat' }
    hl_groups.syntax['@storageclass'] = { link = 'TSStorageClass' }
    hl_groups.syntax['@string'] = { link = 'TSString' }
    hl_groups.syntax['@string.escape'] = { link = 'TSStringEscape' }
    hl_groups.syntax['@string.regex'] = { link = 'TSStringRegex' }
    hl_groups.syntax['@symbol'] = { link = 'TSSymbol' }
    hl_groups.syntax['@tag'] = { link = 'TSTag' }
    hl_groups.syntax['@tag.delimiter'] = { link = 'TSTagDelimiter' }
    hl_groups.syntax['@text'] = { link = 'TSText' }
    hl_groups.syntax['@strike'] = { link = 'TSStrike' }
    hl_groups.syntax['@math'] = { link = 'TSMath' }
    hl_groups.syntax['@type'] = { link = 'TSType' }
    hl_groups.syntax['@type.builtin'] = { link = 'TSTypeBuiltin' }
    hl_groups.syntax['@type.qualifier'] = { link = 'TSKeyword' }
    hl_groups.syntax['@uri'] = { link = 'TSURI' }
    hl_groups.syntax['@variable'] = { link = 'TSVariable' }
    hl_groups.syntax['@variable.builtin'] = { link = 'TSVariableBuiltin' }

    -- lsp
    hl_groups.ui['@none'] = { theme.ui.fg }

    hl_groups.syntax['@lsp.type.property'] = { link = 'TSField' }

    hl_groups.syntax['@lsp.type.namespace'] = { link = 'TSNamespace' }
    hl_groups.syntax['@lsp.type.keyword'] = { link = 'TSKeyword' }

    hl_groups.syntax['@tag.html'] = { theme.syntax.keyword }
    hl_groups.syntax['@tag.delimiter.html'] = { theme.syntax.context }
    hl_groups.syntax['@tag.attribute.html'] = { theme.fg0 }
    hl_groups.syntax['@string.html'] = { theme.nord }

    hl_groups.syntax['@constructor.lua'] = { link = 'Special' }

    hl_groups.syntax['@lsp.type.macro'] = { theme.syntax.macro }
    hl_groups.syntax['@lsp.type.function'] = { 'none' }

    -- fix lsp hover doc
    hl_groups.ui['@none.markdown'] = { 'none', 'none' }
    hl_groups.ui['@text.emphasis'] = { theme.orange, italic = true }

    hl_groups.syntax['markdownH1'] = { theme.ui.purple }
    hl_groups.syntax['markdownH2'] = { theme.ui.green }
    hl_groups.syntax['markdownH3'] = { theme.ui.yellow }
    hl_groups.syntax['markdownH4'] = { link = 'markdownH1' }
    hl_groups.syntax['markdownH5'] = { link = 'markdownH2' }
    hl_groups.syntax['markdownH6'] = { link = 'markdownH3' }

    hl_groups.syntax['@text.title.1.markdown'] = { link = 'markdownH1' }
    hl_groups.syntax['@text.title.2.markdown'] = { link = 'markdownH2' }
    hl_groups.syntax['@text.title.3.markdown'] = { link = 'markdownH3' }
    hl_groups.syntax['@text.title.4.markdown'] = { link = 'markdownH4' }
    hl_groups.syntax['@text.title.5.markdown'] = { link = 'markdownH5' }
    hl_groups.syntax['@text.title.6.markdown'] = { link = 'markdownH6' }

    return hl_groups
  end,
  ---@param props { full?: boolean }
  apply = function(props)
    Util.log('core.ui', 'applying theme')
    local theme = core.lib.hl.__value
    local config = core.lib.options:get('ui', 'general', 'theme_config')
    local hl_groups = require('core.ui.theme').create(theme, config)
    Util.log('core.ui', ('applying "%s" hl groups'):format 'main')
    core.lib.hl.apply(hl_groups.main)
    if props and props.full then
      Util.log('core.ui', ('applying "%s" hl groups'):format 'ui')
      core.lib.hl.apply(hl_groups.ui)
      Util.log('core.ui', ('applying "%s" hl groups'):format 'syntax')
      core.lib.hl.apply(hl_groups.syntax)
    end
  end,
}
