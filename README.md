# ucm.nvim

_Unison at your fingertips_

A little Neovim helper for [Unison](https://www.unison-lang.org/) programming language.

![ucm.nvim](.assets/demo.gif)

## Setup

```lua
{
  'chuwy/ucm.nvim',
  dependencies = {
    'nvim-telescope/telescope.nvim',
    'rcarriga/nvim-notify'              -- A temporary requirement
  },
  config = function()
    require('ucm').setup {
      endpoint = 'http://127.0.0.1:6783/local_ucm/api/'
    }
  end
}
```

The only supported setting now is `endpoint`. You can omit it, but then `ucm.nvim` will be asking you for you API endpoint,
which you can get with `api` command inside `ucm`. Or you can just use a static one, like above with:

```bash
$ ucm --port 6783 --token local_ucm
```

## Usage

This plugin exposes two [Telescope](https://github.com/nvim-telescope/telescope.nvim) pickers:

- `:Telescope ucm list` - here you can navigate Unison namespaces like it's a usual filesystem
- `:Telescope ucm find` - allows you to find terms and types by name as you type

Both pickers insert an entity to edit if you press Return.

It is recommended to invoke `list` first, because it help `ucm.nvim` to find out what project you're working with.
All subsequent `find`s will be working within the project/branch you've selected with `list`.

## FAQ

### Why not LSP?

Doing most of the things the plugin does currently is _likely_ possible via LSP. But at the same time, ucm.nvim is planned to be much
more than just an "interactive symbol viewer" - I plan to add many features (such as adding terms and types, creating and switching projects etc) that are simply out of scope of LSP.

### Why project and branches have so weird names?

This is an ucm issue (the projects are a new concept) which the team is currently working on ([a relevant PR](https://github.com/unisonweb/unison/pull/4250)). ucm.nvim will embrace the changes as soon stable ucm with pretty projects is out.
