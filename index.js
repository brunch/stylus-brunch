'use strict';

var sysPath = require('path');
var stylus = require('stylus');
var nib = require('nib');
var progeny = require('progeny');

function StylusCompiler(cfg) {
  if (cfg == null) cfg = {};
  this.rootPath = cfg.paths.root;
  this.config = (cfg.plugins && cfg.plugins.stylus) || {};
  this.getDependencies = progeny({
    rootPath: this.rootPath
  });
}

StylusCompiler.prototype.brunchPlugin = true;
StylusCompiler.prototype.type = 'stylesheet';
StylusCompiler.prototype.extension = 'styl';

StylusCompiler.prototype.compile = function(data, path, callback) {
  var cfg = this.config;
  var compiler = stylus(data)
    .set('filename', path)
    .set('compress', false)
    .set('firebug', !!cfg.firebug)
    .set('linenos', !!cfg.linenos)
    .set('include css', !!cfg.includeCss)
    .include(sysPath.join(this.rootPath))
    .include(sysPath.dirname(path))
    .use(nib());
  if (cfg !== {}) {
    var defines = cfg.defines || {};
    var paths = cfg.paths;
    var imports = cfg.imports;
    var plugins = cfg.plugins;
    Object.keys(defines).forEach(function(name) {
      compiler.define(name, defines[name]);
    });
    if (Array.isArray(paths)) {
      paths.forEach(function(path) {
        compiler.include(path);
      });
    }
    if (Array.isArray(imports)) {
      imports.forEach(function(relativePath) {
        compiler['import'](relativePath);
      });
    }
    if (Array.isArray(plugins)) {
      var handler = function(plugin) {
        compiler.use(plugin());
      };
      plugins.forEach(function(pluginName) {
        if (typeof define !== 'undefined' && define.amd) {
          require([pluginName], handler);
        } else {
          handler(require(pluginName));
        }
      });
    }
  }
  compiler.render(callback);
};

module.exports = StylusCompiler;
