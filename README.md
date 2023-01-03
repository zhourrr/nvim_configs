# Configuration Files for Vim and Neovim.

I know nothing about lua language, therefore I almost commented everything in the init.lua file. 

It is **_intended to be a minimal configuration which involves only one file (init.lua) that does not exceed 550 lines._**  
Everything else in this repo is not important.

Copy the `init.lua` file to `~/.config/nvim/`  
The required plugins will be installed when you open your Neovim for the first time. I use **_lazy.nvim_** as my plugin manager, so everything should work smoothly. Make sure the following directories are empty before installing plugins:
- **data**: `~/.local/share/nvim`
- **state**: `~/.local/state/nvim`  

The plugins are installed and configured by **_lazy_**, and the relevant setup and keymappings for each plugin are in their **_lazy config_**.

# Screenshots
![Overview](https://user-images.githubusercontent.com/78126249/209620932-6b244873-9da6-47a8-9eb3-91ce6051df0e.png)

## LSP
### Auto-Completion
![Auto-cmp](https://user-images.githubusercontent.com/78126249/209620000-b94f2812-b285-4614-803b-cc0b93657aa2.png)

![Auto-signature-help](https://user-images.githubusercontent.com/78126249/209620276-b3b1bc5f-b1f1-41fa-bd53-fb40745356d3.png)

### Hover and Diagnostics
![Hover](https://user-images.githubusercontent.com/78126249/209624149-55346f70-e4a7-4cd4-8526-f49afbb4870e.png)

![Diagnostics](https://user-images.githubusercontent.com/78126249/209623775-c9fcaaa0-3c17-40ac-a29f-f59e9c542c98.png)

### Goto--Peek definition/declaration/reference/type definition
#### Definition
![Peek-definition](https://user-images.githubusercontent.com/78126249/210198594-540b41bc-e8b2-49e5-b2b6-1994d0db92d1.png)
#### Type Definition
![Peek-type](https://user-images.githubusercontent.com/78126249/210198241-ed1bad3d-7c64-41f2-a89f-b62bd9589ddc.png)
#### Show References
![Show-references](https://user-images.githubusercontent.com/78126249/210198382-094c24a5-9ff8-4c6c-be11-464001864906.png)
#### Peek Reference
![Peek-reference](https://user-images.githubusercontent.com/78126249/210198385-85983106-c805-4d8f-9865-a867f5e57c4f.png)

## Fuzzy Search and Preview
### Find Files
![Find-files](https://user-images.githubusercontent.com/78126249/210262981-0f464ba5-54e2-4aa3-99ad-d55a381d89ac.png)

### Find Strings
![Find-strings](https://user-images.githubusercontent.com/78126249/210263020-d009c0c2-fdf4-4822-bcd7-474436212588.png)

## Git
![Screenshot 11](https://user-images.githubusercontent.com/78126249/209765272-57d87626-4d4f-48ad-b12a-80ef614fcd56.png)
### Commit history
![Commit-history](https://user-images.githubusercontent.com/78126249/210264043-faea9591-7ed4-47a5-aeea-70bba518c532.png)
### Current buffer's commits
![Buffer-commits](https://user-images.githubusercontent.com/78126249/210264091-c8a40c57-07d7-4a77-a5a5-5d7ccd1fdaf7.png)




