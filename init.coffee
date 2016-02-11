# Your init script
#
# Atom will evaluate this file each time a new window is opened. It is run
# after packages are loaded/activated and after the previous editor state
# has been restored.
#
# An example hack to log to the console when each text editor is saved.
#
# atom.workspace.observeTextEditors (editor) ->
#   editor.onDidSave ->
#     console.log "Saved! #{editor.getPath()}"

# Copied script from https://github.com/Tinkerer-/Atom-Init-Pandoc/blob/master/init.coffee to include md2XXXX functions.
path = require 'path'
default_args = ["-S", '--read=markdown+hard_line_breaks+yaml_metadata_block']

MakePandocFile = (extention, args) ->
  [pandoc_args,cwd] =  MakePandocArgs(extention,args)
  spawnchild('pandoc',pandoc_args,cwd)

MakePandocArgs = (extention, args) ->
  editor = atom.workspace.getActiveTextEditor()
  from_path = editor.getPath()
  cwd = path.dirname(from_path)
  to_path = from_path.substr(0, from_path.lastIndexOf('.') + 1) + extention;
  fpath = [from_path]
  #console.log("to path = " + path.dirname(to_path))
  pandoc_args = fpath.concat(args, default_args, ["-o"],[to_path])
  [pandoc_args, cwd]

spawnchild = (cmd,args,cwd) ->
  childProcess = require 'child_process'
  pandoc = childProcess.spawn cmd,args, {cwd}
  pandoc.stdout.on 'data', (d) -> console.log('stdout: ' + d);
  pandoc.stderr.on 'data', (d) -> console.log('stderr: ' + d);
  pandoc.on 'close', (c) -> console.log('child process exited with code ' + c);

atom.commands.add 'atom-text-editor', 'md2:docx': ->
  args = ['--write=docx','-s','--reference-docx=style_templates/BCJ\ Styling.docx']
  MakePandocFile('docx',args)

atom.commands.add 'atom-text-editor', 'md2:html5': ->
	args = ['--write=html5','-s','--css=style_templates/BCJ\ Styling.css']
	MakePandocFile('html',args)

atom.commands.add 'atom-text-editor', 'md2:pdf': ->
  args = ['--write=latex', '-s']
  MakePandocFile('pdf',args)

atom.commands.add 'atom-text-editor', 'md2:reveal.js': ->
  args = ['--to=revealjs','--self-contained','-V','revealjs-url=reveal.js','-V','theme=solarized','-V','transistion=fade','-s']
  MakePandocFile('html',args)
