# vim-testnav

vim-testnav is a simple vim plugin that helps you navigate between a production file and its corresponding test file and vice versa.

It makes the following assumptions in order to work currently:

1. You launch vim from the root directory of your project.
2. You follow a naming convention where your test files end in 'spec' or 'test' before the file's extension.
3. There are not multiple files with the same name / test name. (This will be addressed in a forthcoming version).
