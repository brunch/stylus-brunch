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
    if @config.plugins?.stylus?.spriting
      @iconPath = @config.plugins.stylus.iconPath ? sysPath.join 'images', 'icons'
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
        .set('firebug', !!@config.plugins?.stylus?.firebug)
        .include(sysPath.join @config.paths.root)
        .include(sysPath.dirname path)
        .use(nib())

      if @config.plugins?.stylus
        defines = @config.plugins.stylus.defines ? {}
        Object.keys(defines).forEach (name) ->
          compiler.define name, defines[name]
        @config.plugins.stylus.paths?.forEach (path) ->
          compiler.include(path)
      compiler.render(callback)

  getCompiler: (data, callback) =>
    if @config.plugins?.stylus?.spriting
      options =
        path: @config.plugins.stylus.options?.path or @iconPathFull
        retina: @config.plugins.stylus.options?.retina or '-2x'
        padding: @config.plugins.stylus.options?.padding or 2
        httpPath: @config.plugins.stylus.options?.httpPath or '../' + @iconPath

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
    process.nextTick =>
      callback null, dependencies
