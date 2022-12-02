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


-- load plugins via Packer
-- type :Packer and see the available commands
require("packer").startup(function(use)
    use "wbthomason/packer.nvim"
    use "EdenEast/nightfox.nvim"        -- colorscheme
    use "ggandor/leap.nvim"             -- easymotion
    -- lsp
    use "neovim/nvim-lspconfig" 
    use "williamboman/mason.nvim"
    require"lspconfig".clangd.setup{}
    require("mason").setup()
    -- format
    use "lukas-reineke/indent-blankline.nvim"
    use {
        "nvim-treesitter/nvim-treesitter",
        run = ":TSUpdate",
        require("nvim-treesitter.configs").setup{
            -- language parsers that should always be installed
            ensure_installed = {
                "lua",
                "c",
                "cpp",
                "python",
            },
            highlight = {
                enable = true,
            }
        }
    }
    -- file explorer
    use {
        'nvim-tree/nvim-tree.lua',
        requires = {
        'nvim-tree/nvim-web-devicons',  -- optional, for file icons
        },
        require("nvim-tree").setup({
            sort_by = "case_sensitive",
            view = {
                adaptive_size = true,
            },
            filters = {
                dotfiles = true,
            },
        })
    }
    use { 
        "nvim-telescope/telescope.nvim",
        requires = { {"nvim-lua/plenary.nvim"} }
    }

    -- automatically set up your configuration after cloning packer.nvim
    -- put this at the end after all plugins
    if packer_bootstrap then
        require('packer').sync()
    end
end)


--
-- configurations
--

cmd[[colorscheme nightfox]]

-- line number
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
nmap("<C-s>", "<cmd>w<cr>")
-- leap
nmap("<Leader>f", "<Plug>(leap-forward-to)")
nmap("<Leader>b", "<Plug>(leap-backward-to)")
-- telescope
nmap("<Leader>ff", "<cmd>Telescope find_files<cr>")     -- search files in the current working directory
nmap("<Leader>fo", "<cmd>Telescope buffers<cr>")        -- search opened files
nmap("<Leader>f?", "<cmd>Telescope oldfiles<cr>")       -- search recently opened files
-- nvim-tree
nmap("<C-b>", ":NvimTreeFindFileToggle<CR>")            -- toogle file tree
nmap("<C-k>", ":NvimTreeCollapse<CR>")                  -- collapses the nvim-tree recursively
-- lsp
nmap("gd", "<cmd>lua vim.lsp.buf.definition()<CR>")

