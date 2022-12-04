# Configuration Files for Vim and Neovim.

I know nothing about lua language, therefore I almost commented everything in the init.lua file.

Copy the init.lua file to .config/nvim/  

The required plugins will be installed when you open your Neovim for the first time, so probably it will print some error messages since the plugins are not available (according to my setup order, it should echo something similar to "colorscheme not found error"). After you reopen Neovim, everything should work. 

Note if you have already installed Packer plugin (the plugin manager in my Neovim), then this script will not automatically install required plugins.
