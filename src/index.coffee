nib = require 'nib'
stylus = require 'stylus'
sysPath = require 'path'
sprite = require 'node-sprite'

module.exports = class StylusCompiler
  brunchPlugin: yes
  type: 'stylesheet'
  extension: 'styl'
  _dependencyRegExp: /^ *@import ['"](.*)['"]/

  constructor: (@config) ->
    null

  compile: (data, path, callback) =>        
    iconpath = @config.stylus?.icons or 'images/icons'
    sprite.stylus {path: @config.paths.assets + '/' + iconpath, httpPath : '../' + iconpath }, (err, helper) =>
      compiler = stylus(data)
        .set('compress', no)        
        .set('firebug', !!@config.stylus?.firebug)
        .include(sysPath.join @config.paths.root)
        .include(sysPath.dirname path)
        .use(nib())
        .define('sprite', helper.fn)

      if @config.stylus
        defines = @config.stylus.defines ? {}
        Object.keys(defines).forEach (name) ->
          compiler.define name, defines[name]
        @config.stylus.paths?.forEach (path) ->
          compiler.include(path)
      compiler.render(callback)

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
