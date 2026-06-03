-- Neovim 0.12+ has built-in treesitter support
-- Syntax highlighting is enabled by default
-- The nvim-treesitter plugin has been archived and is no longer needed

-- Custom filetype mappings
vim.filetype.add({
  extension = {
    templ = 'templ',
    tmpl = 'gotmpl',
    tpl = 'gotmpl',
  },
})

-- Register gotmpl language
vim.treesitter.language.register('gotmpl', 'gotmpl')

-- Note: To install additional parsers for languages not bundled with Neovim 0.12:
-- 1. Install tree-sitter-cli: npm install -g tree-sitter-cli
-- 2. Run: :TSInstall <language>
--
-- Bundled parsers in Neovim 0.12 include:
-- bash, c, lua, markdown, python, query, vim, vimdoc
--
-- For other languages (javascript, typescript, go, etc.), use :TSInstall as needed
