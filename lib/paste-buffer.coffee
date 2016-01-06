{CompositeDisposable} = require 'atom'

module.exports = PasteBuffer =
  subscriptions: null
  buffer: []

  config:
    copyIntoSystemClipboard:
      type: 'boolean'
      default: true
      description: 'If true, cut/copy into the system clipboard ' +
        '(in addition to paste-buffer)'
    notifications:
      type: 'boolean'
      default: true
      description: 'Send notifications if there is an error sending code'

  activate: (state) ->
    # Events subscribed to in atom's system can be easily cleaned up with a
    # CompositeDisposable
    @subscriptions = new CompositeDisposable

    @subscriptions.add atom.commands.add 'atom-workspace',
      'paste-buffer:clear': => @clearBuffer()

    @subscriptions.add atom.commands.add 'atom-workspace',
      'paste-buffer:copy': => @copyIntoBuffer()
    @subscriptions.add atom.commands.add 'atom-workspace',
      'paste-buffer:cut': => @cutIntoBuffer()

    @subscriptions.add atom.commands.add 'atom-workspace',
      'paste-buffer:pasteFront': => @pasteBufferFront()
    @subscriptions.add atom.commands.add 'atom-workspace',
      'paste-buffer:pasteBack': => @pasteBufferBack()

    @subscriptions.add atom.commands.add 'atom-workspace',
      'paste-buffer:popFront': => @popBufferFront()
    @subscriptions.add atom.commands.add 'atom-workspace',
      'paste-buffer:popBack': => @popBufferBack()


  deactivate: ->
    @subscriptions.dispose()

  serialize: ->

  copyIntoSystemClipboard: ->
    return atom.config.get 'paste-buffer.copyIntoSystemClipboard'

  notifications: ->
    return atom.config.get 'paste-buffer.notifications'

  editor: ->
    return atom.workspace.getActiveTextEditor()

  conditionalWarning: (message) ->
    if @notifications()
      atom.notifications.addWarning(message)

  cutIntoBuffer: ->
    textLength = @copyIntoBuffer()
    if textLength > 0
      @editor().delete()

  copyIntoBuffer: ->
    text = @editor().getSelectedText()
    if text.length is 0
      @conditionalWarning('paste-buffer: no selection found.')
      return 0
    @buffer[@buffer.length] = text

    if @copyIntoSystemClipboard()
      @editor().copySelectedText()
    return text.length

  clearBuffer: ->
    @buffer = []

  dumpBufferFront: ->
    if @buffer.length > 0
      @buffer.shift()
  dumpBufferBack: ->
    if @buffer.length > 0
      @buffer.pop()

  pasteBufferFront: ->
    if @buffer.length > 0
      @editor().insertText(@buffer[0])
    else
      @conditionalWarning('paste-buffer: buffer empty')
  pasteBufferBack: ->
    if @buffer.length > 0
      @editor().insertText(@buffer[@buffer.length - 1])
    else
      @conditionalWarning('paste-buffer: buffer empty')

  popBufferFront: ->
    if @buffer.length > 0
      @editor().insertText(@buffer.shift())
    else
      @conditionalWarning('paste-buffer: buffer empty')
  popBufferBack: ->
    if @buffer.length > 0
      @editor().insertText(@buffer.pop())
    else
      @conditionalWarning('paste-buffer: buffer empty')
