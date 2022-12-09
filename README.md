# VIM Universal

<a href="https://shawnvim.github.io/vim-universal/"><img src="https://img.shields.io/badge/Wiki-VIM Universal-9cf?style=flat"></a>
<a href="https://github.com/shawnvim/vim-universal/blob/master/LICENSE"><img src="https://img.shields.io/badge/License-Apache 2.0-brightgreen?style=flat"></a>

A universal VIM integration

 - Written in Python and VimL
 - Extended plugins with pack by submodules
 - Support MacOS and Linux-x86_64

## Table of Contents

- [Requirements](#requirements)
- [Installation](#installation)
  - [Engine Init](#engine-init)
- [Package Management](#package-management)
  - [Update](#update)
  - [Deinit](#deinit)
  - [Configuration](#configuration)
- [Reference](#reference)
 
 
## Requirements

 - [Vim8.2](https://github.com/vim/vim) or higher
 - [Python2.7+](https://www.python.org/downloads/release/python-2718/) or [Python3.1+](https://www.python.org/downloads/)

## Installation

In this repo, `git submodule` is used to manage plug-in as package([`/pack`](https://github.com/shawnvim/vim-universal/tree/master/pack))   
Please clone repo with all submodules by:
```
git clone https://github.com/shawnvim/vim-universal --recurse-submodules
```
Or you can just download the `release.zip` with all packages and unzip it to `.vim`  
If you want to keep the folder name as vim-universal, you can use `gvim -u /Path/To/Your/vimrc` to start using

### Engine Init

After initial install, please install the C extension of [Leaderf](https://github.com/Yggdroot/LeaderF#performance) fuzzy matching algorithm:
```vim
:LeaderfInstallCExtension
```
And you can check the installation status after VIM restart by:
```vim
:echo g:Lf_fuzzyEngine_C
```  

## Package Management

### Update
If you want to update with all submodules, please use:
```
git pull origin master && git submodule update --recursive
```  

### Deinit
If you have duplicated plugins locally, you can remove submodule by deinit:
```
git submodule deinit project-sub-1
git rm project-sub-1
```
And then remove the related configuration in [`vimrc`](https://github.com/shawnvim/vim-universal/blob/master/vimrc) and [`autoload/setup`](https://github.com/shawnvim/vim-universal/blob/master/autoload/setup.vim)  

### Configuration
Most of the plug-ins' configuration is in [`autoload/setup`](https://github.com/shawnvim/vim-universal/blob/master/autoload/setup.vim), you can also find the path of all plug-ins in [`.gitmodules`](https://github.com/shawnvim/vim-universal/blob/master/.gitmodules).  
In Vim, you can use <kbd>gx</kbd> to check their Github page and use <kbd>gf</kbd> to go to the file directory.  


## Reference
 - [VIM Universal Wiki](shawnvim.github.io/vim-universal/)
 - [VIM 8 Package Management](https://www.danielfranklin.id.au/vim-8-package-management/)



