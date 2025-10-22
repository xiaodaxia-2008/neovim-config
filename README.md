# 💤 LazyVim

My configuration for [LazyVim](https://github.com/LazyVim/LazyVim).
Refer to the [documentation](https://lazyvim.github.io/installation) to get started.

## 安装依赖

安装一些所需的命令行工具：

```shell
scoop install gzip unzip fzf lazygit ripgrep fd python
``` 

先安装 luarocks, 它会自动安装 lua 5.4，然后安装 lua51, 覆盖 lua5.4 创建的shims。

```
scoop install luarocks
scoop bucket add versions
scoop install versions/lua51
```


## 安装 Fira Code Nerd Font


下载 [Nerd Fonts](https://www.nerdfonts.com/font-downloads)，解压安装。

在 Windows Terminal 中设置相关的配置的字体，选择 `FiraCode Nerd Font Mono`

## 参考书籍

[LazyVim](https://lazyvim-ambitious-devs.phillips.codes/course/chapter-1/#_start_with_a_clean_slate)

> If you already have a Neovim config and you want to try LazyVim without losing your existing configuration, set the ==`NVIM_APPNAME=lazyvim`== environment variable. Skip to the `Clone the starter template` section below, and clone into `~/.config/lazyvim` instead of `~/.config/nvim`. If you want to make the changes permanent, either set `NVIM_APPNAME` in your shell’s startup file or rename that `lazyvim` config folder to `nvim`.
