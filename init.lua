-- disable the default file explorer
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- set up leader key
vim.g.mapleader = " "


--
-- helpers 
--
local cmd = vim.cmd
local opt = vim.opt

-- call set_key_map function
local function map(mode, shortcut, command)
    vim.keymap.set(mode, shortcut, command, { noremap = true, silent = true })
end

-- set normal mode mapping
local function nmap(shortcut, command)
    map('n', shortcut, command)
end

-- set visual mode mapping
local function vmap(shortcut, command)
    map('v', shortcut, command)
end

--
-- load plugins via Packer
-- type :Packer and see the available commands
-- type :checkhealth to check health!
--
local ensure_packer = function()        -- automatically install packer
  local fn = vim.fn
  local install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'
  if fn.empty(fn.glob(install_path)) > 0 then
    fn.system({'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path})
    vim.cmd [[packadd packer.nvim]]
    return true
  end
  return false
end

local packer_bootstrap = ensure_packer()

require("packer").startup(function(use)     -- install plugins
    use "wbthomason/packer.nvim"
    use "EdenEast/nightfox.nvim"            -- colorscheme
    use "ggandor/leap.nvim"            	    -- easymotion
    -- Language Server Protocol (LSP)
    use "nvim-treesitter/nvim-treesitter"   
    use "williamboman/mason.nvim"           -- LSP servers manager
    use "williamboman/mason-lspconfig.nvim" -- helper for mason.nvim
    use "neovim/nvim-lspconfig"             -- Nvim LSP client configs 
    use {
        "hrsh7th/nvim-cmp",                 -- autocompletion engine
        requires = {                        -- autocompletion sources
            "hrsh7th/cmp-nvim-lsp",
            "hrsh7th/cmp-nvim-lsp-signature-help",
            "hrsh7th/cmp-buffer",
            "hrsh7th/cmp-path",
            "hrsh7th/cmp-cmdline"
        }
    }
    -- format
    use "lukas-reineke/indent-blankline.nvim"
    -- file explorer
    use {
        "nvim-tree/nvim-tree.lua",
        requires = { 'nvim-tree/nvim-web-devicons' }    -- optional, for file icons
    }
    use { 
        "nvim-telescope/telescope.nvim",
        requires = { "nvim-lua/plenary.nvim" }
    }

    -- put this at the end after all plugins
    if packer_bootstrap then
        require('packer').install()
        require('packer').sync()
    end
end)


--
-- plugin setup
--
cmd[[colorscheme nightfox]]             -- colorscheme

require("nvim-treesitter.configs").setup {
    -- language parsers that should always be installed
    ensure_installed = {
        --"lua",
        "c",
        "cpp",
        "python"
    },
    highlight = {
        enable = true
    }
}

-- install LSP servers
-- type :mason to see details
require("mason").setup()
require("mason-lspconfig").setup {
    -- language servers that should always be installed
    ensure_installed = {
        "sumneko_lua",
        "clangd",
        --"cmake",
        "rust_analyzer",
        --"pyright"
    }
}

require('telescope').setup {        -- telescope: previewer
   defaults = {
        layout_strategy = "horizontal",
        layout_config = {
            width = 0.9,            -- floating window takes up 90% of the screen
            preview_width = 0.5     -- preview window takes up 50% of the floating window 
        },
        initial_mode = "normal",
        mappings = {
            n = {
                -- kill selected buffer in buffer picker
                ["<Leader>k"] = require("telescope.actions").delete_buffer
            }
        }
   }
}

-- set up LSP configs
local on_attach = function(client, bufnr)   -- has effect only if the language server is active
    local function lsp_map(mode, shortcut, command)
        vim.keymap.set(mode, shortcut, command, { noremap = true, silent = true, buffer = bufnr})
    end

    -- auto format on save
    cmd [[autocmd BufWritePre <buffer> lua vim.lsp.buf.formatting_sync()]]
    nmap('gd', '<cmd>Telescope lsp_definitions<CR>')
    nmap('gr', '<cmd>Telescope lsp_references<CR>')
    nmap('gt', '<cmd>Telescope lsp_type_definitions<CR>')
    nmap('ge', '<cmd>Telescope diagnostics<CR>')
    lsp_map('n', '<Leader>h', vim.lsp.buf.hover)                -- provides documentation
    lsp_map('n', '<Leader>s', vim.lsp.buf.signature_help)       -- provides documentation as you type the argument
    lsp_map('i', '<Leader>s', vim.lsp.buf.signature_help)       -- provides documentation as you type the argument
    lsp_map('n', '<F2>', vim.lsp.buf.rename)                    -- rename a symbol
end

-- configure each language server
require "lspconfig".clangd.setup{ on_attach = on_attach }
require "lspconfig".pyright.setup{ on_attach = on_attach }

-- set up autocompletion engine
opt.completeopt = menu, menuone, noselect
local cmp = require("cmp")
local select_opts = { behavior = cmp.SelectBehavior.Select }

cmp.setup {
    mapping = {
        [ "<CR>" ] = cmp.mapping.confirm({ select = false }),
        [ "<Up>" ] = cmp.mapping.select_prev_item(select_opts),
        [ "<Down>" ] = cmp.mapping.select_next_item(select_opts),
        [ "<Tab>" ] = cmp.mapping(function(fallback)
            if cmp.visible() then
                cmp.select_next_item(select_opts)
            else
                cmp.complete()
            end
        end)
    },
    sources = { -- the order affects the priority
        { name = "nvim_lsp_signature_help", priority = 8 },
        { name = "nvim-lsp", keyword_length = 2, priority = 8 },
        { name = "path" , keyword_length = 2, priority = 1 },
        { name = "buffer", keyword_length = 2, priority = 1 }
    }
}

require("nvim-tree").setup {    -- file explorer
    sort_by = "case_sensitive",
    view = {
        adaptive_size = true    -- the side bar size changes as needed
    },
    renderer = {
        group_empty = true
    },
    filters = {
        dotfiles = true         -- hide dotfiles
    }
}


--
-- configurations
--
opt.number = true
opt.relativenumber = true

-- search
opt.showmatch = true        -- show matching brackets when text indicator is over them
opt.hlsearch = true
nmap("<bs>", ":nohlsearch<cr>") -- BackSpace clears search highlights
opt.incsearch = true
opt.ignorecase = true
opt.smartcase = true        -- works as case-insensitive if you only use lowercase letters;
                            -- otherwise, it will search in case-sensitive mode

-- format
opt.cursorline = true       -- highlight the cursorline
opt.termguicolors = true    -- true color support
opt.wrap = true             -- wrap very long lines to make them look like multiple lines
opt.textwidth = 120         -- character limits in one line
opt.autoindent = true
opt.expandtab = true
opt.tabstop = 4
opt.shiftwidth = 4

-- device
opt.mouse = "nv"            -- normal and visual mode
opt.clipboard = "unnamedplus"

-- display file name on the terminal title
opt.title = true

-- turn backup off, since most stuff is in Git or else anyway...
opt.backup = false
opt.wb = false
opt.swapfile = false

-- special key mappings
nmap("<C-s>", "<cmd>w<cr>")                             -- save file
nmap("<Leader>q", "<cmd>q<cr>")                         -- quit file
-- move cursor by visual lines instead of physical lines when wrapping
nmap("j", "gj")                                         
nmap("k", "gk")
vmap("j", "gj")
vmap("k", "gk")
-- leap
nmap("<Leader>f", "<Plug>(leap-forward-to)")            -- easymotion forward
nmap("<Leader>b", "<Plug>(leap-backward-to)")           -- easymotion backward
-- telescope, t for telescope
-- use navigation keys in telescope, such as j and k; press i to enter insert mode
-- <C-v> vsplit, <C-x> split; 
nmap("<Leader>tf", "<cmd>Telescope find_files<cr>")     -- search for files in the current working directory
nmap("<Leader>tg", "<cmd>Telescope live_grep<cr>")      -- search for strings in the current working directory
nmap("<Leader>tb", "<cmd>Telescope buffers<cr>")        -- list opened files (buffers)
nmap("<Leader>to", "<cmd>Telescope oldfiles<cr>")       -- list recently opened files
-- nvim-tree
-- open a file: <C-v> vsplit, <C-x> split
-- r: rename; a: create; d: remove
nmap("<C-b>", ":NvimTreeFindFileToggle<CR>")            -- toogle file tree
nmap("<C-z>", ":NvimTreeCollapse<CR>")                  -- collapses the nvim-tree recursively

