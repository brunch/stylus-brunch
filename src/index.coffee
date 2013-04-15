{spawn, exec} = require 'child_process'
nib = require 'nib'
fs = require 'fs'
stylus = require 'stylus'
sysPath = require 'path'
sprite = require 'node-sprite'

module.exports = class StylusCompiler
  brunchPlugin: yes
  type: 'stylesheet'
  extension: 'styl'
  _dependencyRegExp: /^ *@import ['"](.*)['"]/

  constructor: (@config) ->
    @config.plugins ?= {}
    if @config.stylus
      console.warn "Warning: config.stylus is deprecated, move it to config.plugins.stylus"
      @config.plugins.stylus ?= @config.stylus

    @cfg = @config.plugins.stylus ? {}

    if @cfg.spriting
      @iconPath = @cfg.iconPath ? sysPath.join 'images', 'icons'
      @iconPathFull = sysPath.join @config.paths.assets, @iconPath
      unless fs.existsSync(@iconPathFull)
         console.error "Please make sure that the icon path #{@iconpath} exits"
      exec 'convert --version', (error, stdout, stderr) =>
        if error
          console.error "You need to have convert (ImageMagick) on your system for spriting"
    null

  compile: (data, path, callback) =>
    @getCompiler data, (compiler) =>
      compiler = compiler
        .set('filename', path)
        .set('compress', no)
        .set('firebug', !!@cfg.firebug)
        .set('linenos', !!@cfg.linenos)
        .include(sysPath.join @config.paths.root)
        .include(sysPath.dirname path)
        .use(nib())

      unless @cfg is {}
        defines = @cfg.defines ? {}
        Object.keys(defines).forEach (name) ->
          compiler.define name, defines[name]
        @cfg.paths?.forEach (path) ->
          compiler.include(path)
      compiler.render(callback)

  getCompiler: (data, callback) =>
    if @cfg.spriting
      cfgopt = @cfg.options
      options =
        path: cfgopt?.path or @iconPathFull
        retina: cfgopt?.retina or '-2x'
        padding: cfgopt?.padding or 2
        httpPath: cfgopt?.httpPath or '../' + @iconPath

      sprite.stylus options, (err, helper) =>
        callback(stylus(data).define('sprite', helper.fn))
    else
      callback(stylus(data))

  getDependencies: (data, path, callback) =>
    parent = sysPath.dirname path
    dependencies = data
      .split('\n')
      .map (line) =>
        line.match(@_dependencyRegExp)
      .filter (match) =>
        match?.length > 0
      .map (match) =>
        match[1]
      .filter (path) =>
        !!path and path isnt 'nib'
      .map (path) =>
        if sysPath.extname(path) isnt ".#{@extension}"
          path + ".#{@extension}"
        else
          path
      .map (path) =>
        if path.charAt(0) is '/'
          sysPath.join @config.paths.root, path[1..]
        else
          sysPath.join parent, path

    # Recursive dependencies
    childs = @getSubDependencies dependencies
    dependencies = dependencies.concat childs if childs.length

    if callback
      process.nextTick =>
        callback null, dependencies
    else
      dependencies

  getSubDependencies: (dependencies) =>
    childs = []
    dependencies.forEach (path) =>
      # Only needed on ignored files e.g.'_file.styl'
      if (sysPath.basename path).charAt(0) is '_' && fs.existsSync path
        fileData = fs.readFileSync path, 'utf8'
        deps = @getDependencies fileData, path
        childs = childs.concat deps if deps.length
    childs
