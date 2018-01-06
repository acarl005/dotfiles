atom.commands.add 'atom-text-editor', 'custom:console-log', ->
  editor = atom.workspace.getActiveTextEditor()
  editor.getSelections().forEach (selection) ->
    selection.insertText 'console.log(' + selection.getText() + ')'
  editor.cursors.forEach (cursor) ->
    cursor.moveLeft 1

atom.commands.add 'atom-text-editor', 'custom:ansi-color', ->
  editor = atom.workspace.getActiveTextEditor()
  editor.getSelections().forEach (selection) ->
    selection.insertText '\\x1b[36m' + selection.getText() + '\\x1b[0m'

atom.commands.add 'atom-text-editor', 'custom:semicolon-end', ->
  editor = atom.workspace.getActiveTextEditor()
  editor.cursors.forEach (cursor) ->
    cursor.moveToEndOfLine()
  editor.insertText ';'

atom.commands.add 'atom-text-editor', 'custom:semicolon-inside', ->
  editor = atom.workspace.getActiveTextEditor()
  editor.cursors.forEach (cursor) ->
    cursor.moveToEndOfLine()
  editor.insertText ';'
  editor.cursors.forEach (cursor) ->
    cursor.moveLeft 2

atom.commands.add 'atom-text-editor', 'custom:remove-block', ->
  editor = atom.workspace.getActiveTextEditor()
  view = atom.views.getView(editor)
  atom.commands.dispatch(view, 'bracket-matcher:select-inside-brackets')
  selection = editor.getSelections()[0]
  range = selection.getScreenRange()
  startLine = range.start.row
  endLine = range.end.row
  selection.outdentSelectedRows()
  selection.selectLine(endLine)
  editor.delete()
  selection.selectLine(startLine)
  editor.delete()
