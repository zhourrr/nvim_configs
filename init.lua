-- Basically, you can type commands in the command mode. 
-- If you want to write a command in your script, usually you can write like this:
-- <cmd>your command<CR>
-- or
-- <cmd>lua require('some-package-name').some-function-name({ argument list })<CR>
-- Note that <cmd> is colon and <CR> is Enter.
-- type :checkhealth to check health!


-- disable the default file explorer
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- disable the clipboard provider
-- I use Windows terminal, therefore I don't need system clipboard at all. 
-- Just enter insert mode, and use your mouse to select the content, right-click (copy) 
-- and go to wherever you want to paste it, and then press Ctrl-v as usual.
vim.g.loaded_clipboard_provider = 0

-- set up leader key
vim.g.mapleader = " "


--
-- helper functions
--
local cmd = vim.cmd
local opt = vim.opt
local function hl(group, highlight) vim.api.nvim_set_hl(0, group, highlight) end    -- set highlight
-- call built-in keymap.set function
local function map(mode, shortcut, command) vim.keymap.set(mode, shortcut, command, { noremap = true, silent = true }) end
local function nmap(shortcut, command) map('n', shortcut, command) end              -- set normal mode mapping
local function vmap(shortcut, command) map('v', shortcut, command) end              -- set visual mode mapping


--
-- general configurations
--
opt.number = true
opt.relativenumber = true
opt.scrolloff = 3                   -- minimal number of screen lines to keep above and below the cursor

-- search
opt.showmatch = true                -- show matching brackets when text indicator is over them
opt.hlsearch = true                 -- highlight search
nmap("<BS>", "<cmd>nohlsearch<CR>") -- BackSpace clears search highlights
opt.incsearch = true                -- incremental search
opt.ignorecase = true               -- works as case-insensitive if you only use lowercase letters;
opt.smartcase = true                -- otherwise, it will search in case-sensitive mode

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

-- device
opt.mouse = "nv"                    -- applied to normal and visual modes

-- turn backup off, since most stuff is in Git or something else anyway...
opt.backup = false
opt.wb = false
opt.swapfile = false

-- special key mappings
opt.timeoutlen = 3000               -- specify the timeout length (in milliseconds) of mapped key sequences
nmap("<C-s>", "<cmd>update<CR>")    -- save changes
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
map("t", "<Esc>", "<C-\\><C-n>")


--
-- load plugins via Lazy, type :Lazy to see available commands
--
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then      -- automatically install "lazy" if not found
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "--single-branch",
        "https://github.com/folke/lazy.nvim.git",
        lazypath
    })
end
opt.runtimepath:prepend(lazypath)

--
-- name:    a custom name for the plugin used for the local plugin directory
-- lazy:    lazy-load or not? the default is false
-- keys:    lazy-load on key mappings
-- event:   lazy-load on event
-- cmd:     lazy-load on command
-- config:  a custom setup function or arguments passed to the default plugin setup function
--
require("lazy").setup {
    -- UI
    {   -- color scheme
        "EdenEast/nightfox.nvim",
	    config = {  -- set comment style
            options = { styles = { comments = "italic" } },
            palettes = { nightfox = { comment = "#ffbcd9" }, dayfox = { comment = "#008000" } }
        } 
    },
    {   -- color scheme
        "catppuccin/nvim",
        name = "catppuccin",
        config = {  -- set comment color
            highlight_overrides = { all = function(colors) return { [ "@comment" ] = { fg = "#008000" } } end }
        }
    },
    {   -- color scheme
        "sainnhe/everforest",
        config = function()
            vim.g.everforest_background = "soft"
            vim.g.everforest_enable_italic = "1"
            vim.api.nvim_create_autocmd( { "ColorSchemePre" }, { command = "set background=dark" } )
        end
    },
    {   -- file explorer
	    "nvim-tree/nvim-tree.lua",
        event = "VeryLazy",
        config = function()
            require("nvim-tree").setup {
                sort_by = "case_sensitive",
                view = { adaptive_size = true },    -- the side bar size changes as needed
                renderer = { group_empty = true },
                filters = { dotfiles = true }       -- hide dotfiles
            }
            -- You can actually use your mouse! Don't be shy.
            -- <Enter> open a file; <C-v> vsplit; <C-x> split; <C-]> cd into the directory;
            -- r: rename; a: create; d: remove; f: create a live filter; F: clear the live filter; 
            -- H: toggle dotfiles; I: toggle git-ignore;
            -- P: go to parent node; <BackSpace>: close current opened directory;
            -- c: copy file/directory; p: paste file/directory;
            -- Icon indicates when a file is (Git Integration):
            --      ✗  unstaged or folder is dirty
            --      ✓  staged
            --      ★  new file
            --      ✓ ✗ partially staged
            --      ✓ ★ new file staged
            --      ✓ ★ ✗ new file staged and has unstaged modifications
            --      ═  merging
            --      ➜  renamed
            nmap("<C-b>", ":NvimTreeFindFileToggle<CR>")    -- toggle file tree
            nmap("<C-z>", ":NvimTreeCollapse<CR>")          -- collapses the nvim-tree recursively
        end
    },
    {   -- show indents
        "echasnovski/mini.indentscope",
        event = "BufReadPost",
        config = function() require("mini.indentscope").setup{ symbol = "|" } end
    },
    {   -- status line
        "nvim-lualine/lualine.nvim",
        event = "VeryLazy",
        config = {
           options = {
               icons_enabled = true,
               globalstatus = true,     -- enable global statusline (only a single statusline at the bottom of neovim)
               theme = "catppuccin",
               -- left refers to the left-most sections (mode, etc.)  
               -- right refers to the right-most sections (location, etc.)
               section_separators = { left = ' ', right = ' ' },
               component_separators = { left = '|', right = '|' }
           },
           sections = {                 -- what components to display in each section?
               lualine_a = { 'mode' },
               lualine_b = { 'hostname', 'branch', 
                    { 
                        'filename', path = 1,   -- show relative file path
                        symbols = {             -- symbols for file status
                            modified = '[M]', readonly = '[R]',
                            unnamed = '[No Name]', newfile = '[New]'
                        }
                    } 
                },
                lualine_c = { 'diff', 'diagnostics', 'searchcount' },
                lualine_x = { 'encoding', 'fileformat', 'filetype' },
                lualine_y = { 'progress' }, lualine_z = { 'location' }
            }
        }
    },
    -- dependency
    { "nvim-lua/plenary.nvim" },
    { "nvim-tree/nvim-web-devicons", config = true },   -- file icons
    -- utility
    {   -- toggle comments
        "terrortylor/nvim-comment",
        name = "nvim_comment",
        keys = { { "<Leader>c", mode = "n" }, { "<Leader>c", mode = "v" } },
        config = {
            create_mappings = true,
            line_mapping = "<Leader>cc",    -- in normal mode, comment the current line
            operator_mapping = "<Leader>c"  -- in visual mode, comment the selected lines
        }
    },
    {   -- easymotion
        "ggandor/leap.nvim",
        keys = { "<Leader>f", "<Leader>b" },
        config = function()
            nmap("<Leader>f", "<Plug>(leap-forward-to)")    -- easymotion forward
            nmap("<Leader>b", "<Plug>(leap-backward-to)")   -- easymotion backward
        end
    },
    {   -- smooth scroll
        "echasnovski/mini.animate",
        event = "CursorHold",
        keys = { '<C-u>', '<C-d>', 'zt', 'zz', 'zb' },
        config = function() require("mini.animate").setup() end
    },
    {   -- highlight cursor word's references
        "echasnovski/mini.cursorword", 
        event = { "BufReadPost", "CursorHold" },
        config = function() 
            require("mini.cursorword").setup()
            local function hl_cursor() hl("MiniCursorword", { italic = true, bold = true, standout = true }) end
            hl_cursor()                     -- set highlight format of MiniCursorword
            vim.api.nvim_create_autocmd( { "ColorScheme" }, { callback = hl_cursor } )
            local function toggle_cursor()  -- toggle cursor word highlight
                vim.g.minicursorword_disable = not vim.g.minicursorword_disable
                MiniCursorword.auto_unhighlight()
                MiniCursorword.auto_highlight()
            end
            nmap("<Leader>h", toggle_cursor)
        end
    },
    {   -- auto-pair
        "windwp/nvim-autopairs",
        event = "InsertEnter",
        config = {
            disable_in_macro = false,       -- disable when recording or executing a macro
            enable_moveright = true,
            map_cr = true,                  -- map <CR> key
            map_bs = true,             	    -- map <BS> key
            map_c_h = false,           	    -- do not map <C-h> key to delete a pair
            map_c_w = false           	    -- do not map <C-w> to delete a pair if possible
        }
    },
    {   -- picker and previewer
        "nvim-telescope/telescope.nvim",
        event = "VeryLazy",
        config = function()
            require("telescope").setup {
                defaults = {
                    sorting_strategy = "ascending",     -- the direction "better" results are sorted towards
                    layout_strategy = "vertical",
                    layout_config = {
                        vertical = {
                            scroll_speed = 7,           -- use <C-d> and <C-u> to scroll the preview screen
                            height = 0.95,              -- floating window takes up 95% of the screen's vertical space
                            width = 0.95,               -- floating window takes up 95% of the screen's horizontal space
                            preview_height = 0.6,       -- preview window takes up 60% of the floating window
                            preview_cutoff = 20         -- disable preview when lines are less than this value
                        }
                    },
                    initial_mode = "normal",        -- starts in normal mode, press i to enter insert mode
                    mappings = {
                        n = {
                            -- kill selected buffer in buffer picker
                            [ "<Leader>k" ] = require("telescope.actions").delete_buffer,
                            -- toggle preview
                            [ "<Leader>o" ] = require("telescope.actions.layout").toggle_preview
                        }
                    },
                    preview = { hide_on_startup = false }           -- show preview window when picker starts
                },
                pickers = {
                    find_files = { initial_mode = "insert" },       -- starts in insert mode
                    grep_string = { initial_mode = "insert" },
                    live_grep = { initial_mode = "insert" },
                    keymaps = { initial_mode = "insert" }
                }
            }
            -- t for telescope; use navigation keys in telescope, such as j, k, <C-d> and <C-u>. 
            -- <C-v> vsplit, <C-x> split;
            nmap("<Leader>tk", "<cmd>Telescope keymaps<CR>")        -- lists key mappings
            nmap("<Leader>tf", "<cmd>Telescope find_files<CR>")     -- searches for files in the current working directory
            nmap("<Leader>tb", "<cmd>Telescope buffers sort_mru=true ignore_current_buffer=true<CR>")   -- lists opened files
            nmap("<Leader>to", "<cmd>Telescope oldfiles<CR>")       -- lists recently opened files
            nmap('<Leader>te', '<cmd>Telescope diagnostics<CR>')    -- lists errors
            -- live_grep:           exact matches in the current working directory
            -- live_grep returns exact matches for the current query after each key press. Therefore it can't be fuzzy 
            -- unless the grep tool provides a fuzzy engine.
            nmap("<Leader>tl", "<cmd>Telescope live_grep<CR>")
            -- grep_string:         exact matches for the current query, then allows user to apply fuzzy filter.
            nmap("<Leader>tg", "<cmd>Telescope grep_string<CR>")
            -- grep_empty_string:   fuzzy search in the current working directory
            -- With an empty string as the initial query, fuzzy filter is applied to every line in the directory.
            -- This might be slow on large projects!
            nmap("<Leader>tz", "<cmd>lua require('telescope.builtin').grep_string({ only_sort_text = true, search = '' })<CR>")
            nmap("<Leader>tr", "<cmd>Telescope resume<CR>")         -- lists results of the previous picker
            -- Telescope git integration, v for version control
            nmap("<Leader>tvc", "<cmd>Telescope git_commits<CR>")   -- git commits, press <CR> to checkout commit
            nmap("<Leader>tvbc", "<cmd>Telescope git_bcommits<CR>") -- current buffer's git commits 
            nmap("<Leader>tvbr", "<cmd>Telescope git_branches<CR>") -- git branches
            nmap("<Leader>tvs", "<cmd>Telescope git_status<CR>")    -- git status
        end
    },
    {   -- language parser and highlighter
        "nvim-treesitter/nvim-treesitter",
        event = { "BufReadPost", "CursorHold" },
        config = function()
	        require("nvim-treesitter.configs").setup{
                -- language parsers that should always be installed
                ensure_installed = { "lua", "c", "cpp", "python" },
                highlight = { enable = true },
                indent = { enable = true },
                incremental_selection = {                           -- smart selection powered by treesitter
                    enable = true,
                    keymaps = {
                        init_selection = "<Leader><CR>",            -- select the area under the cursor
                        node_incremental = "<CR>",                  -- increment a little bit
                        scope_incremental = "<TAB>",                -- increment a lot
                        node_decremental = "<BS>"                   -- decrement a little bit
                    }
                }
            }
            opt.foldmethod = "expr"                                 -- smart folding powered by tree-sitter
            opt.foldexpr = "nvim_treesitter#foldexpr()"
            opt.foldenable = false
            hl("Folded", { fg = "red", bg = "None", bold = true })  -- highlight folded
        end
    },
    {   -- sticky scroll
        "nvim-treesitter/nvim-treesitter-context",
        event = { "BufReadPost", "CursorHold" },
        config = true
    },
    {   -- git integration
        "lewis6991/gitsigns.nvim",
        event = { "BufReadPost", "CursorHold" },
        config = {
            preview_config = { border = "rounded" },
            on_attach = function(bufnr)
                local gs = package.loaded.gitsigns
                -- navigation
                nmap("<Leader>n", gs.next_hunk)
                nmap("<Leader>p", gs.prev_hunk)
                -- preview
                nmap("<Leader>v", gs.preview_hunk)
                nmap("<Leader>l", gs.blame_line)        -- the last person who touched this line
                -- stage, unstage and reset
                nmap("<Leader>s", gs.stage_hunk)
                nmap("<Leader>u", gs.undo_stage_hunk)
                nmap("<Leader>r", gs.reset_hunk)
            end
        }
    },
    -- Language Server Protocol (LSP)
    {   -- LSP servers manager, which automatically install LSP server. Type :mason to see more details
        "williamboman/mason.nvim",
        event = { "BufReadPost", "CursorHold" },
        config = { ui = { icons = { package_installed = "✓", package_pending = "➜", package_uninstalled = "✗" } } }
    },
    {   -- helper for mason.nvim
        "williamboman/mason-lspconfig.nvim",
        event = { "BufReadPost", "CursorHold" },
        config = {  -- language servers that should always be installed
            ensure_installed = { "clangd", "rust_analyzer" }
        }
    },
    {   -- Nvim LSP client configs. Type :lsp to see available commands, such as LspInfo
        -- I use mason to install servers. 
        -- You can also install servers manually, and then add the following line in your LSP setup.
        --      cmd = { "path-to-your-language-server-executable" } 
        --      Example:
        --          require("lspconfig").clangd.setup {
        --              cmd = { "path-to-your-clangd-server-executable" }, on_attach = on_attach
        --          }
        "neovim/nvim-lspconfig",
        event = { "BufReadPost", "CursorHold" },
        config = function()
            -- set up LSP floating window border
            local border_opt = { border = "rounded" }
            vim.diagnostic.config{ float = border_opt }
            vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, border_opt)
            vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, border_opt)
            -- LSP services
            local on_attach = function(client, bufnr)                   -- has effects only if the language server is active
                nmap('gd', '<cmd>Telescope lsp_definitions<CR>')
                nmap('gD', vim.lsp.buf.declaration)
                nmap('gr', "<cmd>lua require('goto-preview').goto_preview_references()<CR>")
                nmap('gt', '<cmd>Telescope lsp_type_definitions<CR>')
                nmap('gci', '<cmd>Telescope lsp_incoming_calls<CR>')    -- call hierarchy: incoming
                nmap('gco', '<cmd>Telescope lsp_outgoing_calls<CR>')    -- call hierarchy: outgoing
                nmap('gb', '<cmd>Telescope lsp_document_symbols<CR>')   -- list symbols in the current buffer
                nmap('gw', '<cmd>Telescope lsp_workspace_symbols<CR>')  -- list symbols in the current workspace
                nmap('ga', vim.lsp.buf.code_action)                     -- code actions, such as quick fixes
                nmap('gh', vim.lsp.buf.hover)                           -- provides documentation
                nmap('gs', vim.lsp.buf.signature_help)                  -- provides documentation about the arguments
                nmap('gf', vim.lsp.buf.format)                          -- format the current file
                nmap('gn', vim.lsp.buf.rename)                          -- rename a symbol
                nmap('ge', vim.diagnostic.open_float)                   -- print error message in a floating window
                nmap('[e', vim.diagnostic.goto_prev)                    -- go to the previous error
                nmap(']e', vim.diagnostic.goto_next)                    -- go to the next error
            end
            -- configure each language server
            require("lspconfig").clangd.setup { on_attach = on_attach } -- note that Clangd provides a switch command, try it!
        end
    },
    {   -- LSP preview in a floating window
        "rmagatti/goto-preview",
        event = { "BufReadPost", "CursorHold" },
        config = function()
            require('goto-preview').setup {
                width = 120,                -- Width of the floating window
                height = 17,                -- Height of the floating window
                references = {              -- Configure the telescope UI for showing the references cycling window.
                    telescope = require("telescope.themes").get_dropdown({
                        hide_preview = false, 
                        layout_strategy = "center",
                        layout_config = { width = 0.85 }
                    })
                },
                post_open_hook = function(buffer, win)  -- a hook function called after the floating window is opened
                    local function map(shortcut, command)
                        vim.api.nvim_buf_set_keymap(buffer, "n", shortcut, command, { noremap = true, silent = true })
                    end
                    cmd("TSContextEnable")                                              -- give context information
                    map("<Leader><Leader>", "<cmd>q<CR><cmd>Telescope resume<CR>")      -- switch among references
                end
            }
            nmap('gpd', "<cmd>lua require('goto-preview').goto_preview_definition()<CR>")
            nmap('gpt', "<cmd>lua require('goto-preview').goto_preview_type_definition()<CR>")
        end
    },
    {   -- autocompletion engine
        "hrsh7th/nvim-cmp",
        event = { "InsertEnter", "CmdlineEnter", "CursorHold" },
        dependencies = {        -- autocompletion sources
            "hrsh7th/cmp-nvim-lsp",
            "hrsh7th/cmp-nvim-lsp-signature-help",
            "hrsh7th/cmp-buffer",
            "hrsh7th/cmp-path",
            "hrsh7th/cmp-cmdline",
        },
        config = function()     -- set up autocompletion engine
            opt.completeopt = { "menu", "menuone", "noselect" }         -- autocompletion menu options
            local cmp = require("cmp")
            local select_opts = { behavior = cmp.SelectBehavior.Select }
            local has_chars_before = function()                         -- check if there is something before the current cursor
                local line, col = unpack(vim.api.nvim_win_get_cursor(0))
                return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
            end
            cmp.setup {
                mapping = {
                    ["<CR>"] = cmp.mapping.confirm({ select = false }),
                    ["<C-p>"] = cmp.mapping.select_prev_item(select_opts),
                    ["<C-n>"] = cmp.mapping.select_next_item(select_opts),
                    ["<Tab>"] = cmp.mapping(function(fallback)
                        if cmp.visible() then                       -- tab scrolls down
                            cmp.select_next_item(select_opts)
                        elseif has_chars_before() then
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
                    fields = { "kind", "abbr", "menu" },                    -- display these fields
                    format = function(entry, vim_item)                      -- format the fields
                        vim_item.kind = string.format("%s", vim_item.kind)  -- what kind of object is it?
                        vim_item.abbr = string.sub(vim_item.abbr, 1, 100)   -- set up a max width on completion entries
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
            cmp.setup.cmdline({ "/", "?" }, {           -- in-file search should use source: buffer
                mapping = cmp.mapping.preset.cmdline(),
                sources = { { name = "buffer" } }
            })
            cmp.setup.cmdline(":", {                    -- commandline autocompletion uses special sources
                mapping = cmp.mapping.preset.cmdline(),
                sources = cmp.config.sources({ { name = "path" } }, { { name = "cmdline" } })
            })
            -- add parentheses after selecting function or method item
            cmp.event:on("confirm_done", require("nvim-autopairs.completion.cmp").on_confirm_done())
        end
    }
}

-- highlight window separators
vim.api.nvim_create_autocmd(
    { "ColorScheme" }, { callback = function() hl("WinSeparator", { fg = "orange", bg = "None" }) end }
)

-- random themes
themes = { "nightfox", "catppuccin-mocha", "dayfox", "everforest" }
cmd("colorscheme " .. themes[1 + math.random(os.time()) % 4])

-- show macro visual feedback
vim.api.nvim_create_autocmd( { "RecordingEnter" }, { command = "set cmdheight=1" })
vim.api.nvim_create_autocmd( { "RecordingLeave" }, { command = "set cmdheight=0" })

