# paste-buffer package

The `paste-buffer` package allows you to store several clipboards at a time
and paste them in order.

No commands are bound by default so you will have to bind them yourself.
If you don't know how to do this, check out the "Customizing Key Bindings" section in the [Atom flight manual](https://atom.io/docs/v1.3.2/using-atom-basic-customization).

## commands

Here is a brief description of the commands:

- `paste-buffer:copy` copy the text into the buffer
- `paste-buffer:cut` cut the text into the buffer
- `paste-buffer:pasteFront` paste the front of the buffer (leaving the buffer intact)
- `paste-buffer:pasteBack` paste the back of the buffer (leaving the buffer intact)
- `paste-buffer:popFront` paste and remove the front of the buffer
- `paste-buffer:popBack` paste and remove the back of the buffer
