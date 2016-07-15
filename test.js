'use strict';
const expect = require('chai').expect;
const Plugin = require('./');
const fs = require('fs');
const sysPath = require('path');
const fixturesPath = sysPath.resolve(__dirname, 'fixtures');

describe('Plugin', function() {
  let plugin;
  const path = 'fixtures/app/styles/style.styl';

  beforeEach(function() {
    plugin = new Plugin({
      paths: {
        root: ''
      },
      plugins: {
        stylus: {
          paths: [fixturesPath],
          defines: {
            url: require('stylus').url()
          }
        }
      }
    });
  });

  it('should be an object', () => {
    expect(plugin).to.be.an('object');
  });

  describe('#compile', () => {
    it('should have #compile method', () => {
      expect(plugin).to.respondTo('compile');
    });

    it('should compile and produce valid result', () => {
      const imagePath = './dot.jpg';
      const base64 = fs.readFileSync(`${fixturesPath}/${imagePath}`).toString('base64');

      const data = `body\n  font: 12px Helvetica, Arial, sans-serif\n  background: url("${imagePath}")`;
      const expected = `body {\n  font: 12px Helvetica, Arial, sans-serif;\n  background: url("data:image/jpeg;base64,${base64}");\n}\n`;

      return plugin.compile({data, path}).then(result => {
        expect(result.data).to.equal(expected);
      });
    });

    it('should compile and import from config.stylus.paths', () => {
      const data = "@import 'path_test'\n";
      const expected = '.test {\n  color: #fff;\n}\n';

      return plugin.compile({data, path}).then(result => {
        expect(result.data).to.equal(expected);
      });
    });
  });

  describe('getDependencies', () => {
    it('should output valid deps', () => {
      const data = `
        @import unquoted
        @import 'valid1'
        @import '__--valid2--'
        @import "./valid3.styl"
        @import '../../vendor/styles/valid4'
        @import 'nib'
        // @import 'commented'
      `;

      const expected = [
        sysPath.join('fixtures', 'app', 'styles', 'unquoted.styl'),
        sysPath.join('fixtures', 'app', 'styles', 'valid1.styl'),
        sysPath.join('fixtures', 'app', 'styles', '__--valid2--.styl'),
        sysPath.join('fixtures', 'app', 'styles', 'valid3.styl'),
        sysPath.join('fixtures', 'vendor', 'styles', 'valid4.styl')
      ];

      return plugin.getDependencies({data, path}).then(deps => {
        expect(deps).to.deep.equal(expected);
      });
    });

    it('should match globs', () => {
      const data = '@import styles/*';
      const path = 'fixtures/app/glob_test.styl';

      const expected = [
        sysPath.join('fixtures', 'app', 'styles', 'unquoted.styl'),
        sysPath.join('fixtures', 'app', 'styles', 'valid1.styl'),
        sysPath.join('fixtures', 'app', 'styles', '__--valid2--.styl'),
        sysPath.join('fixtures', 'app', 'styles', 'valid3.styl'),
      ].sort();

      return plugin.getDependencies({data, path}).then(deps => {
        expect(deps.sort()).to.deep.equal(expected);
      });
    });
  });
});
