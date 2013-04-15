var fs = require('fs');
var sysPath = require('path');
var supportFolder = sysPath.join(sysPath.basename(__dirname), 'support');
var supportPath = sysPath.resolve(__dirname, 'support');

describe('Plugin', function() {
  var plugin;
  var fileName = 'app/styles/style.styl';

  beforeEach(function() {
    plugin = new Plugin({
      paths: {
        root: ''
      },
      stylus: {
        paths: [supportPath],
        defines: {
          url: require('stylus').url()
        }
      }
    });
  });

  it('should be an object', function() {
    expect(plugin).to.be.ok;
  });

  describe('#compile', function() {
    it('should has #compile method', function() {
      expect(plugin.compile).to.be.an.instanceof(Function);
    });

    it('should compile and produce valid result', function(done) {
      var urlTest = {
        imagePath: 'img/dot.jpg'
      }

      urlTest.base64 = fs.readFileSync(supportPath + '/' + urlTest.imagePath).toString('base64');
      var content = 'body\n  font: 12px Helvetica, Arial, sans-serif\n  background: url("' + urlTest.imagePath + '")';
      var expected = 'body {\n  font: 12px Helvetica, Arial, sans-serif;\n  background: url("data:image/jpeg;base64,' + urlTest.base64 + '");\n}\n';

      plugin.compile(content, fileName, function(error, data) {
        expect(error).to.equal(null);
        expect(data).to.equal(expected)
        done();
      });
    });

    it('should compile and import from config.stylus.paths', function(done){
      var content = "@import 'path_test'\n";
      var expected = '.test {\n  color: #fff;\n}\n';

      plugin.compile(content, fileName, function(error, data) {
        expect(error).to.equal(null);
        expect(data).to.equal(expected);
        done();
      });
    });
  });

  describe('getDependencies', function() {
    it('should output valid deps', function(done) {
      var content = "\
@import _invalid\n\
@import 'valid1'\n\
@import '__--valid2--'\n\
@import \"./valid3.styl\"\n\
@import '../../vendor/styles/valid4'\n\
@import 'nib'\n\
// @import 'commented'\n\
";

      var expected = [
        sysPath.join('app', 'styles', 'valid1.styl'),
        sysPath.join('app', 'styles', '__--valid2--.styl'),
        sysPath.join('app', 'styles', 'valid3.styl'),
        sysPath.join('vendor', 'styles', 'valid4.styl')
      ];

      plugin.getDependencies(content, fileName, function(error, dependencies) {
        expect(error).not.to.be.ok;
        expect(dependencies).to.eql(expected);
        done();
      });
    });

    it('should output recursive deps when ignored files', function(done){
      var content = "@import '_recursive_test'\n";
      var expected = [
        sysPath.join(supportFolder, '_recursive_test.styl'),
        sysPath.join(supportFolder, 'path_test.styl')
      ];

      plugin.getDependencies(content, supportFolder + '/test.styl', function(error, dependencies) {
        expect(error).not.to.be.ok;
        expect(dependencies).to.eql(expected);
        done();
      });
    });

    it('should not output recursive deps when not ignored files', function(done){
      var content = "@import 'recursive_test'\n";
      var expected = [
        sysPath.join(supportFolder, 'recursive_test.styl')
      ];

      plugin.getDependencies(content, supportFolder + '/test.styl', function(error, dependencies) {
        expect(error).not.to.be.ok;
        expect(dependencies).to.eql(expected);
        done();
      });
    });
  });
});
