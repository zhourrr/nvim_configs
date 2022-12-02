-- disable the default file explorer
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1


--
-- helpers 
--
local cmd = vim.cmd
local opt = vim.opt

-- call set_key_map function
local function map(mode, shortcut, command)
    vim.api.nvim_set_keymap(mode, shortcut, command, { noremap = true, silent = true })
end

-- set normal mode mapping
local function nmap(shortcut, command)
    map('n', shortcut, command)
end


--
-- load plugins via Packer
-- type :Packer and see the available commands
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

require("nvim-treesitter.configs").setup{
    -- language parsers that should always be installed
    ensure_installed = {
        "lua",
        "c",
        "cpp",
        "python"
    },
    highlight = {
        enable = true
    }
}

-- install LSP servers
require("mason").setup()
require("mason-lspconfig").setup({
    -- language servers that should always be installed
    ensure_installed = {
        "sumneko_lua",
        "clangd",
        "cmake",
        "rust_analyzer",
        "pyright"
    }
})

-- set up LSP configs
local on_attach = function(client, bufnr)
    local function lsp_map(mode, shortcut, command)
        vim.keymap.set(mode, shortcut, command, { noremap = true, silent = true, buffer = bufnr})
    end

    lsp_map('n', 'gd', vim.lsp.buf.definition)
    lsp_map('n', 'gr', vim.lsp.buf.references)
    lsp_map('n', '<Leader>k', vim.lsp.buf.hover)            -- provides documentation
    lsp_map('n', '<F2>', vim.lsp.buf.rename)
    lsp_map('n', '<C-k>', vim.lsp.buf.signature_help)       -- provides documentation as you type the argument
    lsp_map('i', '<C-k>', vim.lsp.buf.signature_help)       -- provides documentation as you type the argument
    lsp_map('n', 'go', vim.diagnostic.open_float)
      --vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, bufopts)
      --vim.keymap.set('n', '<leader>d', '<cmd>Telescope lsp_document_symbols<cr>', bufopts)
end
require"lspconfig".clangd.setup{ on_attach = on_attach }
require"lspconfig".pyright.setup{ on_attach = on_attach }

-- file explorer
require("nvim-tree").setup({
    sort_by = "case_sensitive",
    view = {
        adaptive_size = true
    },
    filters = {
        dotfiles = true
    }
})


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
opt.wrap = false
opt.textwidth = 120
opt.autoindent = true
opt.expandtab = true
opt.tabstop = 4
opt.shiftwidth = 4

-- mouse
opt.mouse = "nv"

-- display file name on the terminal title
opt.title = true

-- turn backup off, since most stuff is in Git or else anyway...
opt.backup = false
opt.wb = false
opt.swapfile = false

-- special key mappings
vim.g.mapleader = " "
nmap("<C-s>", "<cmd>w<cr>")                             -- save file
nmap("<Leader>q", "<cmd>q<cr>")                         -- quit file
-- leap
nmap("<Leader>f", "<Plug>(leap-forward-to)")
nmap("<Leader>b", "<Plug>(leap-backward-to)")
-- telescope
nmap("<Leader>tf", "<cmd>Telescope find_files<cr>")     -- search files in the current working directory
nmap("<Leader>to", "<cmd>Telescope buffers<cr>")        -- search opened files
nmap("<Leader>t?", "<cmd>Telescope oldfiles<cr>")       -- search recently opened files
-- nvim-tree
nmap("<C-b>", ":NvimTreeFindFileToggle<CR>")            -- toogle file tree
--nmap("<C-k>", ":NvimTreeCollapse<CR>")                  -- collapses the nvim-tree recursively

