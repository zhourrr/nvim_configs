-- Basically, you can type commands in the command mode. 
-- If you want to write a command in your script, usually you can write like this:
-- <cmd>your command<CR>
-- or
-- <cmd>lua require('some-package-name').some-function-name({ argument list })<CR>
-- Note that <cmd> is colon and <CR> is Enter.


-- disable the default file explorer
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- set up leader key
vim.g.mapleader = " "


--
-- helpers and set_key_mapping functions
--
local cmd = vim.cmd
local opt = vim.opt
-- call built-in keymap.set function
local function map(mode, shortcut, command)
    vim.keymap.set(mode, shortcut, command, { noremap = true, silent = true })
end
-- helper function for setting normal mode mapping
local function nmap(shortcut, command)
    map('n', shortcut, command)
end
-- helper function for setting visual mode mapping
local function vmap(shortcut, command)
    map('v', shortcut, command)
end

--
-- load plugins via Packer
-- type :Packer and see the available commands
-- type :checkhealth to check health!
--
local ensure_packer = function()                -- automatically install packer
    local fn = vim.fn
    local install_path = fn.stdpath('data') .. '/site/pack/packer/start/packer.nvim'
    if fn.empty(fn.glob(install_path)) > 0 then
        fn.system({ 'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path })
        vim.cmd [[packadd packer.nvim]]
        return true
    end
    return false
end

local packer_bootstrap = ensure_packer()

require("packer").startup(function(use)             -- install plugins
    use "wbthomason/packer.nvim"                    -- plugin manager
    use "EdenEast/nightfox.nvim"                    -- colorscheme
    use "ggandor/leap.nvim"                         -- easymotion
    use "lukas-reineke/indent-blankline.nvim"       -- show indents
    use "terrortylor/nvim-comment"                  -- toggle comments
    use "karb94/neoscroll.nvim"                     -- smooth scroll
    use "nvim-lualine/lualine.nvim"                 -- status line
    -- Language Server Protocol (LSP)
    use "nvim-treesitter/nvim-treesitter"           -- highlight
    use "nvim-treesitter/nvim-treesitter-context"   -- sticky scroll
    use "williamboman/mason.nvim"                   -- LSP servers manager
    use "williamboman/mason-lspconfig.nvim"         -- helper for mason.nvim
    use "neovim/nvim-lspconfig"                     -- Nvim LSP client configs
    use {
        "hrsh7th/nvim-cmp",                         -- autocompletion engine
        requires = {                                -- autocompletion sources
            "hrsh7th/cmp-nvim-lsp",
            "hrsh7th/cmp-nvim-lsp-signature-help",
            "hrsh7th/cmp-buffer",
            "hrsh7th/cmp-path",
            "hrsh7th/cmp-cmdline"
        }
    }
    -- file explorer
    use "nvim-tree/nvim-web-devicons"               -- file icons
    use "nvim-tree/nvim-tree.lua"
    use {
        "nvim-telescope/telescope.nvim",
        requires = { "nvim-lua/plenary.nvim" }
    }
    use "lewis6991/gitsigns.nvim"                   -- git integration

    -- put this at the end after all plugins
    if packer_bootstrap then
        require('packer').install()
        require('packer').sync()
    end
end)


--
-- plugin setup
--
require('nightfox').setup {                     -- colorscheme
    options = {
        styles = { comments = "italic" }
    },
    palettes = {
        nightfox = { comment = "#ffbcd9" },     -- set comment color
        dayfox = { comment = "#008000" },
        nordfox = { comment = "#ffbcd9" },
        carbonfox = { comment = "#ffbcd9" }
    }
}

cmd [[colorscheme nightfox]]        -- colorscheme

require("nvim_comment").setup {     -- toggle comments
    create_mappings = true,
    line_mapping = "<Leader>cc",    -- in normal mode, comment the current line
    operator_mapping = "<Leader>c"  -- in visual mode, comment the selected lines
}

require("neoscroll").setup{ mappings = { '<C-u>', '<C-d>', 'zt', 'zz', 'zb' } }

require("nvim-web-devicons").setup()

require('lualine').setup {
    options = {
        icons_enabled = false,      -- disable icons since I don't intend to install extra fonts
        globalstatus = true,        -- enable global statusline (only a single statusline at the bottom of neovim)
        theme = "dracula",
        -- left refers to the left-most sections (mode, etc.)  
        -- right refers to the right-most sections (location, etc.)
        section_separators = { left = ' ', right = ' ' },
        component_separators = { left = '|', right = '|' }
    },
    sections = {                    -- what components to display in each section?
        lualine_a = { 'mode' },
        lualine_b = { 
            'hostname', 
            'branch',
            { 
                'filename',
                path = 1, 
                symbols = {
                    modified = '[M]',
                    readonly = '[R]',
                    unnamed = '[No Name]',
                    newfile = '[New]'
                }
            } 
        },
        lualine_c = { 'diff', 'diagnostics', 'searchcount' },
        lualine_x = { 'encoding', 'fileformat', 'filetype' },
        lualine_y = { 'progress' },
        lualine_z = { 'location' }
    }
}
-- highlight window separators
vim.api.nvim_create_autocmd(
    { "BufWinEnter" },
    { command = "lua vim.api.nvim_set_hl(0, 'WinSeparator', { fg = 'yellow', bg = 'None', bold = true })" }
)

require("nvim-treesitter.configs").setup {
    -- language parsers that should always be installed
    ensure_installed = {
        "c",
        "cpp",
        "python"
    },
    highlight = { enable = true }
}

require('telescope').setup {            -- telescope: picker and previewer
    defaults = {
        sorting_strategy = "ascending", -- the direction "better" results are sorted towards
        layout_strategy = "horizontal",
        layout_config = {
            width = 0.95,               -- floating window takes up 95% of the screen
            preview_width = 0.85,       -- preview window takes up 85% of the floating window
            preview_cutoff = 20         -- disable preview when columns are less than this value
        },
        initial_mode = "normal",        -- starts in normal mode, press i to enter insert mode
        mappings = {
            n = {
                -- kill selected buffer in buffer picker
                [ "<Leader>k" ] = require("telescope.actions").delete_buffer,
                -- toggle preview
                [ "<Leader>m" ] = require("telescope.actions.layout").toggle_preview
            }
        },
        preview = { hide_on_startup = true }            -- hides preview window when picker starts
    },
    pickers = {
        find_files = { initial_mode = "insert" },       -- starts in insert mode
        grep_string = { initial_mode = "insert" },
        live_grep = { initial_mode = "insert" }
    }
}

-- Install LSP servers
-- I am using mason.nvim to automatically install LSP server. Type :mason to see more details
-- You can also install servers manually, and then add the following line in your LSP setup.
--      cmd = { "path-to-your-language-server-executable" } 
--      Example:
--          require("lspconfig").clangd.setup {
--              cmd = { "path-to-your-clangd-server-executable" },
--              on_attach = on_attach
--          }
require("mason").setup()
require("mason-lspconfig").setup {
    -- language servers that should always be installed
    ensure_installed = {
        "clangd",
        "rust_analyzer"
    }
}

-- set up LSP configs
-- type :lsp to see available commands, such as LspInfo
local on_attach = function(client, bufnr)                   -- has effects only if the language server is active
    -- lsp services
    nmap('gd', '<cmd>Telescope lsp_definitions<CR>')
    nmap('gD', vim.lsp.buf.declaration)
    nmap('gr', '<cmd>Telescope lsp_references<CR>')
    nmap('gt', '<cmd>Telescope lsp_type_definitions<CR>')
    nmap('gci', '<cmd>Telescope lsp_incoming_calls<CR>')    -- call hierarchy: incoming
    nmap('gco', '<cmd>Telescope lsp_outgoing_calls<CR>')    -- call hierarchy: outgoing
    nmap('gb', '<cmd>Telescope lsp_document_symbols<CR>')   -- list symbols in the current buffer
    nmap('gw', '<cmd>Telescope lsp_workspace_symbols<CR>')  -- list symbols in the current workspace
    nmap('ge', vim.diagnostic.open_float)                   -- print error message in a floating window
    nmap('ga', vim.lsp.buf.code_action)                     -- code actions, such as quick fixes
    nmap('gh', vim.lsp.buf.hover)                           -- provides documentation
    nmap('gs', vim.lsp.buf.signature_help)                  -- provides documentation as you type the argument
    nmap('gf', vim.lsp.buf.format)                          -- format the current file
    nmap('<F2>', vim.lsp.buf.rename)                        -- rename a symbol
end

-- configure each language server
require("lspconfig").clangd.setup { on_attach = on_attach }
-- require("lspconfig").pylsp.setup { on_attach = on_attach }

-- set up autocompletion engine
opt.completeopt = { "menu", "menuone", "noselect" }         -- autocompletion menu
local cmp = require("cmp")
local select_opts = { behavior = cmp.SelectBehavior.Select }
local has_words_before = function()                         -- check if there is a word before the current cursor
    local line, col = unpack(vim.api.nvim_win_get_cursor(0))
    return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
end

cmp.setup {
    mapping = {
        ["<CR>"] = cmp.mapping.confirm({ select = false }),
        ["<Up>"] = cmp.mapping.select_prev_item(select_opts),
        ["<Down>"] = cmp.mapping.select_next_item(select_opts),
        ["<Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then                       -- tab scrolls down
                cmp.select_next_item(select_opts)
            elseif has_words_before() then
                cmp.complete()
            else
                fallback()                              -- don't complete for an empty word
            end
        end, { "i", "c" })                              -- applied to insert and command mode
    },
    sources = {     -- the order might affect the priority
                    -- keyword length controls how many characters are necessary to begin querying the source
        { name = "nvim_lsp_signature_help", keyword_length = 1, priority = 8 },
        { name = "nvim_lsp", keyword_length = 2, priority = 7 },
        { name = "path", keyword_length = 2, priority = 1 },
        { name = "buffer", keyword_length = 4, priority = 1 }
    },
    formatting = {  -- autocompletion menu format
        fields = { "kind", "abbr", "menu" },
        format = function(entry, vim_item)
            vim_item.kind = string.format("%s", vim_item.kind)  -- what kind of object is it?
            vim_item.menu = ({                                  -- source name
                nvim_lsp_signature_help = "[LSP_sig]",
                nvim_lsp = "[LSP]",
                buffer = "[Buffer]",
                path = "[Path]"
            })[entry.source.name]
            return vim_item
        end
    },
    window = {      -- I like borders...
        completion = cmp.config.window.bordered(),
        documentation = cmp.config.window.bordered()
    }
}

cmp.setup.cmdline({ "/", "?" }, {   -- in-file search should use source: buffer
    mapping = cmp.mapping.preset.cmdline(),
    sources = {
        { name = "buffer" }
    }
})
cmp.setup.cmdline(":", {            -- commandline autocompletion uses special sources
    mapping = cmp.mapping.preset.cmdline(),
    sources = cmp.config.sources({
        { name = "path" }
    }, {
        { name = "cmdline" }
    })
})

require("nvim-tree").setup {        -- file explorer, see below for mappings
    sort_by = "case_sensitive",
    view = {
        adaptive_size = true        -- the side bar size changes as needed
    },
    renderer = {
        group_empty = true
    },
    filters = {
        dotfiles = true             -- hide dotfiles
    }
}

require("gitsigns").setup {
    on_attach = function(bufnr)
        local gs = package.loaded.gitsigns
        -- navigation
        nmap("<Leader>n", gs.next_hunk)
        nmap("<Leader>p", gs.prev_hunk)
        -- preview
        nmap("<Leader>v", gs.preview_hunk)
        nmap("<Leader>l", gs.blame_line)
        -- stage, unstage and reset
        nmap("<Leader>s", gs.stage_hunk)
        nmap("<Leader>u", gs.undo_stage_hunk)
        nmap("<Leader>r", gs.reset_hunk)
    end
}


--
-- general configurations
--
opt.number = true
opt.relativenumber = true

-- search
opt.showmatch = true                -- show matching brackets when text indicator is over them
opt.hlsearch = true
nmap("<BS>", ":nohlsearch<CR>")     -- BackSpace clears search highlights
opt.incsearch = true
opt.ignorecase = true
opt.smartcase = true                -- works as case-insensitive if you only use lowercase letters;
                                    -- otherwise, it will search in case-sensitive mode

-- format
opt.cursorline = true               -- highlight the cursorline
opt.cmdheight = 0                   -- hide command line
opt.termguicolors = true            -- true color support
opt.wrap = true                     -- wrap very long lines to make them look like multiple lines
opt.textwidth = 120                 -- the upper limit of the number of characters in one line
opt.autoindent = true
opt.expandtab = true
opt.tabstop = 4
opt.shiftwidth = 4
opt.spell = false                   -- enable spell checker in comments, use zg or zw to mark words as good or wrong
opt.spelloptions = "camel"          -- be smart with camelCased words

-- folding
opt.foldmethod = "expr"             -- smart folding by tree-sitter
opt.foldexpr = "nvim_treesitter#foldexpr()"
opt.foldenable = false
vim.api.nvim_set_hl(0, 'Folded', { fg = 'red', bold = true, bg = 'None' })  -- highlight folded

-- device
opt.mouse = "nv"                    -- applied to normal and visual modes
opt.clipboard = "unnamedplus"

-- display file name on the terminal title
opt.title = true

-- turn backup off, since most stuff is in Git or something else anyway...
opt.backup = false
opt.wb = false
opt.swapfile = false

-- special key mappings
opt.timeoutlen = 3000               -- specify the timeout length (in milliseconds) of mapped key sequences
nmap("<C-s>", "<cmd>w<CR>")         -- save file
nmap("<Leader>q", "<cmd>q<CR>")     -- quit file
nmap("<Leader>w", "<C-w>")          -- window operations, note that you can type <C-w>w to switch to floating window
nmap("<Leader><Leader>", "<C-^>")   -- go to the alternate buffer

-- move cursor by visual lines instead of physical lines when wrapping
nmap("j", "gj")
nmap("k", "gk")
vmap("j", "gj")
vmap("k", "gk")

-- Neovim terminal mode
-- type :term to enter the terminal 
-- type <Esc> to enter normal mode in the terminal, then you can use file explorer to switch buffers
map("t", "<Esc>", "<C-\\><C-n>", { noremap = true, silent = true })

-- leap
nmap("<Leader>f", "<Plug>(leap-forward-to)")            -- easymotion forward
nmap("<Leader>b", "<Plug>(leap-backward-to)")           -- easymotion backward

-- telescope, t for telescope
-- use navigation keys in telescope, such as j and k; press i to enter insert mode
-- <C-v> vsplit, <C-x> split;
nmap("<Leader>tf", "<cmd>Telescope find_files<CR>")     -- searches for files in the current working directory
nmap("<Leader>tb", "<cmd>Telescope buffers sort_mru=true ignore_current_buffer=true<CR>")   -- lists opened files
nmap("<Leader>to", "<cmd>Telescope oldfiles<CR>")       -- lists recently opened files
nmap('<Leader>te', '<cmd>Telescope diagnostics<CR>')    -- lists errors
-- live_grep:           exact matches in the current working directory
-- live_grep returns exact matches for the current query after each key press. Therefore it can't be fuzzy unless the
-- grep tool provides a fuzzy engine.
nmap("<Leader>tg", "<cmd>Telescope live_grep<CR>")
-- grep_empty_string:   fuzzy search in the current working directory
-- grep_string returns all exact matches for the current query, then allows user to apply fuzzy filter.
-- I use an empty string as the initial query, so essentially I am applying fuzzy filter on every line in the directory.
-- This might be slow on large projects!
nmap("<Leader>tz", "<cmd>lua require('telescope.builtin').grep_string({ only_sort_text = true, search = '' })<CR>")
nmap("<Leader>tr", "<cmd>Telescope resume<CR>")

-- nvim-tree, you can actually use your mouse!
-- <Enter> open a file; <C-v> vsplit; <C-x> split; <C-]> cd into the directory;
-- r: rename; a: create; d: remove; f: create a live filter; F: clear the live filter; 
-- H: toggle dotfiles; I: toggle git-ignore;
-- P: go to parent node; <BackSpace>: close current opened directory;
-- c: copy file/directory; p: paste file/directory;
-- Git Integration: 
-- Icon indicates when a file is:
--      ✗  unstaged or folder is dirty
--      ✓  staged
--      ★  new file
--      ✓ ✗ partially staged
--      ✓ ★ new file staged
--      ✓ ★ ✗ new file staged and has unstaged modifications
--      ═  merging
--      ➜  renamed
nmap("<C-b>", ":NvimTreeFindFileToggle<CR>")            -- toggle file tree
nmap("<C-z>", ":NvimTreeCollapse<CR>")                  -- collapses the nvim-tree recursively

