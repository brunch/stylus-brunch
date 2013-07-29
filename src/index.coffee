{spawn, exec} = require 'child_process'
nib = require 'nib'
fs = require 'fs'
stylus = require 'stylus'
sysPath = require 'path'
sprite = require 'node-sprite'
progeny = require 'progeny'

module.exports = class StylusCompiler
  brunchPlugin: yes
  type: 'stylesheet'
  extension: 'styl'

  constructor: (@config) ->
    if @config.stylus
      console.warn "Warning: config.stylus is deprecated, move it to config.plugins.stylus"
      @cfg = @config.stylus
    else
      @cfg = if @config.plugins?.stylus? then @config.plugins.stylus else {}

    if @cfg.spriting
      @iconPath = @cfg.iconPath ? sysPath.join 'images', 'icons'
      @iconPathFull = sysPath.join @config.paths.assets, @iconPath
      unless fs.existsSync(@iconPathFull)
         console.error "Please make sure that the icon path #{@iconpath} exits"
      exec 'convert --version', (error, stdout, stderr) =>
        if error
          console.error "You need to have convert (ImageMagick) on your system for spriting"

    @getDependencies = progeny rootPath: @config.paths.root

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
        @cfg.imports?.forEach (relativePath) ->
          compiler.import(relativePath)
        @cfg.plugins?.forEach (pluginName) ->
          handler = (plugin) => compiler.use(plugin())
          if define?.amd
            require [pluginName], handler
          else
            handler require pluginName

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
