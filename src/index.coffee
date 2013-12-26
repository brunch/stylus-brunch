{spawn, exec} = require 'child_process'
nib = require 'nib'
fs = require 'fs'
stylus = require 'stylus'
sysPath = require 'path'
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

    @getDependencies = progeny rootPath: @config.paths.root

  compile: (data, path, callback) =>
    compiler = stylus(data)
      .set('filename', path)
      .set('compress', no)
      .set('firebug', !!@cfg.firebug)
      .set('linenos', !!@cfg.linenos)
      .set('include css', !!@cfg.includeCss)
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
