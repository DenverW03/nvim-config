-- v-- Config settings --v

-- Numbers on lines
vim.opt.number = true

-- Don't show the mode (visual etc)
vim.opt.showmode = false

-- Save undo history
vim.opt.undofile = true

-- Case insensitive searching
vim.opt.ignorecase = true

-- Keep sign column on
vim.opt.signcolumn = 'yes'

-- New split opening
vim.opt.splitright = true
vim.opt.splitbelow = true

-- How some whitespace is shown
vim.opt.list = true
vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }

-- Preview substitutions live
vim.opt.inccommand = 'split'

-- Show line cursor is on
vim.opt.cursorline = true

-- Min number of screen lines to keep above and below the cursor
vim.opt.scrolloff = 10

-- Split navigation keybinds
vim.keymap.set('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
vim.keymap.set('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
vim.keymap.set('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
vim.keymap.set('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })

-- Highlight on yank
vim.api.nvim_create_autocmd('TextYankPost', {
    desc = 'Highlight when yanking (copying) text',
    group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
    callback = function()
      vim.highlight.on_yank()
    end,
})

-- v-- Plugin shit --v

vim.cmd([[
"" Plugins!!
call plug#begin()

"" Treesitter for parsing stuff!
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}

"" Mason manager for LSPs
Plug 'williamboman/mason.nvim'

"" Setup for nvim-cmp
Plug 'neovim/nvim-lspconfig'
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/cmp-path'
Plug 'hrsh7th/cmp-cmdline'
Plug 'hrsh7th/nvim-cmp'

"" Snipping engine
Plug 'hrsh7th/cmp-vsnip'
Plug 'hrsh7th/vim-vsnip'

"" Telescope for finding stuff!
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim', { 'tag': '0.1.8' }

"" Theme for aesthetics obviously
Plug 'NLKNguyen/papercolor-theme'
Plug 'tiagovla/tokyodark.nvim'

call plug#end()

"" Activating the theme
set background=dark
""colorscheme PaperColor
colorscheme tokyodark

"" Some keybindings
:map <F12> :Telescope buffers <CR>
:map <F10> :tabnew <CR>
:map <F9> :Telescope find_files <CR>
]])

-- Setup mason
require("mason").setup()


-- Set up nvim-cmp.
local cmp = require'cmp'

cmp.setup({
snippet = {
    expand = function(args)
    vim.fn["vsnip#anonymous"](args.body) -- For `vsnip` users.
    -- vim.snippet.expand(args.body) -- For native neovim snippets (Neovim v0.10+)
    end,
},
window = {
    -- completion = cmp.config.window.bordered(),
    -- documentation = cmp.config.window.bordered(),
},
mapping = cmp.mapping.preset.insert({
    ['<C-b>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<C-e>'] = cmp.mapping.abort(),
    ['<CR>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
}),
sources = cmp.config.sources({
    { name = 'nvim_lsp' },
    { name = 'vsnip' }, -- For vsnip users.
}, {
    { name = 'buffer' },
})
})

-- To use git you need to install the plugin petertriho/cmp-git and uncomment lines below
-- Set configuration for specific filetype.
--[[ cmp.setup.filetype('gitcommit', {
sources = cmp.config.sources({
    { name = 'git' },
}, {
    { name = 'buffer' },
})
})
require("cmp_git").setup() ]]-- 

-- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline({ '/', '?' }, {
mapping = cmp.mapping.preset.cmdline(),
sources = {
    { name = 'buffer' }
}
})

-- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline(':', {
mapping = cmp.mapping.preset.cmdline(),
sources = cmp.config.sources({
    { name = 'path' }
}, {
    { name = 'cmdline' }
}),
matching = { disallow_symbol_nonprefix_matching = false }
})

-- The language servers installed:
-- css-lsp                                                                                               
-- eslint_d
-- gopls
-- html-lsp
-- pyright
-- rust-analyzer
-- typescript-language-server

-- Set up lspconfig.
local capabilities = require('cmp_nvim_lsp').default_capabilities()
-- Replace <YOUR_LSP_SERVER> with each lsp server you've enabled.
require('lspconfig')['clangd'].setup {
    capabilities = capabilities
}
require('lspconfig')['rust_analyzer'].setup {
    capabilities = capabilities,
}
require('lspconfig')['pyright'].setup {
    capabilities = capabilities,
}
require('lspconfig')['gopls'].setup {
    capabilities = capabilities
}
require('lspconfig')['html'].setup {
    capabilities = capabilities
}
require('lspconfig')['cssls'].setup {
    capabilities = capabilities
}
require('lspconfig')['tsserver'].setup {
    capabilities = capabilities
}
