'use strict';

const sysPath = require('path');
const stylus = require('stylus');
const nib = require('nib');
const progeny = require('progeny');

const postcss = require('postcss');
const postcssModules = require('postcss-modules');

const cssModulify = (path, data, map) => {
  let json = {};
  const getJSON = (_, _json) => json = _json;

  return postcss([postcssModules({getJSON})]).process(data, {from: path, map}).then(x => {
    const exports = 'module.exports = ' + JSON.stringify(json) + ';';
    return { data: x.css, map: x.map, exports };
  });
};

class StylusCompiler {
  constructor(cfg) {
    if (cfg == null) cfg = {};
    this.rootPath = cfg.paths.root;
    this.config = cfg.plugins && cfg.plugins.stylus || {};
    this.getDependencies = progeny({rootPath: this.rootPath});
    this.modules = this.config.modules || this.config.cssModules;
    delete this.config.modules;
    delete this.config.cssModules;
  }

  compile(params) {
    const data = params.data;
    const path = params.path;

    const cfg = this.config;
    const compiler = stylus(data)
      .set('filename', path)
      .set('compress', false)
      .set('firebug', !!cfg.firebug)
      .set('linenos', !!cfg.linenos)
      .set('include css', !!cfg.includeCss)
      .include(sysPath.join(this.rootPath))
      .include(sysPath.dirname(path))
      .use(nib());

    if (cfg !== {}) {
      const defines = cfg.defines || {};
      const paths = cfg.paths;
      const imports = cfg.imports;
      const plugins = cfg.plugins;

      Object.keys(defines).forEach(name => compiler.define(name, defines[name]));

      if (Array.isArray(paths)) {
        paths.forEach(path => compiler.include(path));
      }
      if (Array.isArray(imports)) {
        imports.forEach(relativePath => compiler['import'](relativePath));
      }
      if (Array.isArray(plugins)) {
        const handler = plugin => compiler.use(plugin());
        plugins.forEach(pluginName => {
          if (typeof define !== 'undefined' && define.amd) { //eslint-disable-line no-undef
            require([pluginName], handler);
          } else {
            handler(require(pluginName));
          }
        });
      }
    }

    return new Promise((resolve, reject) => {
      compiler.render((error, data) => {
        if (error) return reject(error);

        if (this.modules) {
          cssModulify(path, data).then(resolve, reject);
        } else {
          resolve({data});
        }
      });
    });
  }
}

StylusCompiler.prototype.brunchPlugin = true;
StylusCompiler.prototype.type = 'stylesheet';
StylusCompiler.prototype.extension = 'styl';


module.exports = StylusCompiler;
