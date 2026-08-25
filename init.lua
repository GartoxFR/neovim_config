vim.g.mapleader = " "
-- Prevents showing extra messages when using completion
vim.opt.shortmess:append("c")
-- Sets the height of the command line area at the bottom
vim.opt.cmdheight = 1
-- Displays the line number for the current line
vim.opt.number = true
-- Displays line numbers relative to the current cursor position
vim.opt.relativenumber = true
-- Time in milliseconds to wait for a mapped sequence to complete
vim.opt.timeoutlen = 500
-- Time in milliseconds of inactivity before calling CursorHold or writing to swap
vim.opt.updatetime = 4000
-- Ignores case when searching patterns
vim.opt.ignorecase = true
-- Automatically switches to case-sensitive search if a capital letter is used
vim.opt.smartcase = true
-- Enables 24-bit RGB colors in the terminal
vim.opt.termguicolors = true
-- Configures the behavior of the insert mode completion menu
vim.opt.completeopt = "menu,menuone,noselect,popup"
-- Number of spaces that a <Tab> character represents
vim.opt.tabstop = 4
-- Number of spaces to use for each step of automatic indentation
vim.opt.shiftwidth = 4
-- Number of spaces that a <Tab> counts for during editing operations
vim.opt.softtabstop = 4
-- Converts tabs into spaces when typing
vim.opt.expandtab = true
-- Automatically inserts an extra level of indentation in some cases
vim.opt.smartindent = true
-- Makes <Tab> insert 'shiftwidth' number of spaces at the start of a line
vim.opt.smarttab = true
-- Disable use of swapfile
vim.opt.swapfile = false
-- Don't fold anything by default
vim.opt.foldlevelstart = 99

-- No line wrap by default
vim.opt.wrap = false

-- We want to enable autocomplete only in non promt buffers
vim.bo.autocomplete = vim.bo.buftype ~= 'prompt'

vim.pack.add({
    -- Color theme
    { src = "https://github.com/neanias/everforest-nvim" },
    -- Config for lsp
    { src = "https://github.com/neovim/nvim-lspconfig" },
    -- File picker
    { src = "https://github.com/folke/snacks.nvim" },
    -- File browser
    { src = "https://github.com/X3eRo0/dired.nvim" },
    -- Dired dependency
    { src = "https://github.com/MunifTanjim/nui.nvim" },
    -- Emacs compile mode in nvim
    { src = "https://github.com/ej-shafran/compile-mode.nvim" },
    { src = "https://github.com/nvim-lua/plenary.nvim" },

    { src = 'https://github.com/nvim-tree/nvim-web-devicons' },

    -- Treesitter
    { src = "https://github.com/nvim-treesitter/nvim-treesitter" },

    -- Nice scrollbar
    { src = "https://github.com/lewis6991/satellite.nvim" },

    -- Surround shortcuts
    { src = "https://github.com/kylechui/nvim-surround" },

})

vim.lsp.config("rust_analyzer", {
    settings = {
        ["rust_analyzer"] = {
            cargo = {
                allFeatures = true,
                loadOutDirsFromCheck = true,
                buildScripts = {
                    enable = true,
                },
            },
            lru = {
                capacity = 2048,
            },
            -- Add clippy lints for Rust if using rust-analyzer
            checkOnSave = true,
            check = {
                command = "clippy",
                args = {
                    "--frozen",
                    "--offline",
                    "--",
                    "-W",
                    "warnings"
                }
            },
            -- Enable diagnostics if using rust-analyzer
            diagnostics = {
                enable = true,
            },
            procMacro = {
                enable = true,
                ignored = {
                    ["async-trait"] = { "async_trait" },
                    ["napi-derive"] = { "napi" },
                    ["async-recursion"] = { "async_recursion" },
                },
            },
            files = {
                excludeDirs = {
                    ".direnv",
                    ".git",
                    ".github",
                    ".gitlab",
                    "bin",
                    "node_modules",
                    "target",
                    "venv",
                    ".venv",
                },
            },
        },
    },
}
)

vim.opt.background = "light"


local everforest = require("everforest")
everforest.setup({
    background = "soft",
})

everforest.load()

vim.api.nvim_create_autocmd("LspAttach", {
    group = vim.api.nvim_create_augroup("lsp_completion", { clear = true }),
    callback = function(args)
        local client_id = args.data.client_id
        if not client_id then
            return
        end

        local client = vim.lsp.get_client_by_id(client_id)
        if client and client:supports_method("textDocument/completion") then
            -- Enable native LSP completion for this client + buffer
            vim.lsp.completion.enable(true, client_id, args.buf, {
                autotrigger = true, -- auto-show menu as you type (recommended)
                -- You can also set { autotrigger = false } and trigger manually with <C-x><C-o>
            })
        end
    end,
})

vim.lsp.enable('lua_ls')

require('vim._core.ui2').enable({})

require('dired').setup({
    override_cwd = false,
})

-- I find <leader>w to be easier to use window keybinds
vim.keymap.set('n', '<leader>w', '<C-w>')

-- Goto last buffer
vim.keymap.set('n', '<leader>,', ':b#<CR>', { silent = true })

local Snacks = require('snacks')
Snacks.setup({})
vim.keymap.set('n', '<leader><space>', function() Snacks.picker.smart() end)
vim.keymap.set('n', '<leader>.', function() Snacks.picker.buffers() end)
vim.keymap.set('n', '<leader>sg', function() Snacks.picker.grep() end)
vim.keymap.set('n', '<leader>sw', function() Snacks.picker.grep_word() end)
vim.keymap.set('n', "<leader>sd", function() Snacks.picker.diagnostics() end)

vim.keymap.set('n', '<leader>gg', function() Snacks.lazygit() end)

vim.keymap.set('n', "gd", function() Snacks.picker.lsp_definitions() end)
vim.keymap.set('n', "gD", function() Snacks.picker.lsp_declarations() end)
vim.keymap.set('n', "grr", function() Snacks.picker.lsp_references() end)
vim.keymap.set('n', "gri", function() Snacks.picker.lsp_implementations() end)
vim.keymap.set('n', "grt", function() Snacks.picker.lsp_type_definitions() end)
vim.keymap.set('n', "gai", function() Snacks.picker.lsp_incoming_calls() end)
vim.keymap.set('n', "gao", function() Snacks.picker.lsp_outgoing_calls() end)

vim.keymap.set('n', "grf", function() vim.lsp.buf.format() end)

-- Create some toggle mappings
Snacks.toggle.option("spell", { name = "Spelling" }):map("<leader>us")
Snacks.toggle.option("wrap", { name = "Wrap" }):map("<leader>uw")
Snacks.toggle.diagnostics():map("<leader>ud")
Snacks.toggle.option("conceallevel", { off = 0, on = vim.o.conceallevel > 0 and vim.o.conceallevel or 2 }):map(
    "<leader>uc")
Snacks.toggle.inlay_hints():map("<leader>uh")

vim.keymap.set('n', '<leader>d', ':Dired %<cr>')

local compile_mode = require('compile-mode')
vim.g.compile_mode = {}

vim.keymap.set('n', '<C-c><C-c>', function() compile_mode.compile() end)
vim.keymap.set('n', '<C-c><C-r>', function() compile_mode.recompile() end)

local treesitter = require('nvim-treesitter')
treesitter.setup {
    -- Directory to install parsers and queries to (prepended to `runtimepath` to have priority)
    install_dir = vim.fn.stdpath('data') .. '/site'
}

local treesitter_supported = { 'rust', 'c', 'cpp', 'typst', 'bash', 'lua' }
treesitter.install(treesitter_supported)

vim.api.nvim_create_autocmd('FileType', {
    group = vim.api.nvim_create_augroup("tree-sitter-enable", { clear = true }),
    callback = function(args)
        local lang = vim.treesitter.language.get_lang(args.match)
        if not lang or not vim.treesitter.language.add(lang) then return end

        if vim.treesitter.query.get(lang, "highlights") then vim.treesitter.start(args.buf) end

        if vim.treesitter.query.get(lang, "indents") then
            vim.opt_local.indentexpr = 'v:lua.require("nvim-treesitter").indentexpr()'
        end

        if vim.treesitter.query.get(lang, "folds") then
            vim.opt_local.foldmethod = "expr"
            vim.opt_local.foldexpr = "v:lua.vim.treesitter.foldexpr()"
        end
    end,
})

require("lualine-setup")
require("hlslens-setup")
require("gitsigns-setup")
