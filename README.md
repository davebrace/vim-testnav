# vim-testnav

vim-testnav is a simple vim plugin that helps you navigate between a production file and its corresponding test file and vice versa.

It makes the following assumptions in order to work currently:

1. You launch vim from the root directory of your project (the VIM working directory is the root of the project).
2. You follow a naming convention where your test files end in '_spec' or '_test' before the file's extension.

# Installation

If you're using pathogen, the following command should install the plugin for you:

```
cd ~/.vim/bundle && git clone git@github.com:davebrace/vim-testnav.git
```

# Keyboard shortcuts

vim-testnav binds navigating between a prod file and the test alternate to `<Leader>.` by default.
