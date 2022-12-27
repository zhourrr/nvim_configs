# Configuration Files for Vim and Neovim.

I know nothing about lua language, therefore I almost commented everything in the init.lua file. 

It is **_intended to be a minimal configuration which involves only one file that does not exceed 500 lines._**

Copy the `init.lua` file to `~/.config/nvim/`  
The required plugins will be installed when you open your Neovim for the first time, so probably it will print some error messages since the plugins are not available (according to my setup order, it should echo something similar to "colorscheme not found error"). After you reopen Neovim, everything should work.

Note if you have already installed Packer plugin (the plugin manager in my Neovim), then this script will not automatically install required plugins.

# Screenshots
![Screenshot 1](https://user-images.githubusercontent.com/78126249/209620932-6b244873-9da6-47a8-9eb3-91ce6051df0e.png)

## LSP and Git
### Auto-Completion
![Screenshot 2](https://user-images.githubusercontent.com/78126249/209620000-b94f2812-b285-4614-803b-cc0b93657aa2.png)

![Screenshot 3](https://user-images.githubusercontent.com/78126249/209620276-b3b1bc5f-b1f1-41fa-bd53-fb40745356d3.png)

### Hover and Diagnostics

![screenshot_6](https://user-images.githubusercontent.com/78126249/207720397-82822eef-274e-4c22-9a01-6ae86e55a324.png)


## Fuzzy Search and Preview
### Find Files
![screenshot_7](https://user-images.githubusercontent.com/78126249/207732847-96d6216a-77a7-4f67-801f-e3ef82d31152.png)

![screenshot_8](https://user-images.githubusercontent.com/78126249/207732877-2ead0afa-d1bd-483e-97ba-15c310536dbc.png)

### Find Strings
![screenshot_9](https://user-images.githubusercontent.com/78126249/207732884-25d0ca61-feb9-4b45-ab7a-b7fbe39d69d1.png)

![screenshot_10](https://user-images.githubusercontent.com/78126249/207732657-08cd49a7-4046-416e-9f5a-b162b07230c1.png)
