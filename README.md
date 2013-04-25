## stylus-brunch
Adds [Stylus](http://learnboost.github.com/stylus/) support to
[brunch](http://brunch.io).

Also includes [nib](http://visionmedia.github.com/nib/) cross-browser mixins.

## Usage
Install the plugin via npm with `npm install --save stylus-brunch`.

Or, do manual install:

* Add `"stylus-brunch": "x.y.z"` to `package.json` of your brunch app.
  Pick a plugin version that corresponds to your minor (y) brunch version.
* If you want to use git version of plugin, add
`"stylus-brunch": "git+ssh://git@github.com:brunch/stylus-brunch.git"`.

## Options
### Spriting
You can enable sass-like spriting by node-sprint with config directive
`config.plugins.stylus.spriting` (set it to true).
Path to sprites is configurable via `config.plugins.stylus.iconPath`
(default is `app/assets/images/icons`).

### Use Plugin Middleware
You can include Stylus plugins with a config directive
`config.plugins.stylus.plugins` (array) with paths to require the needed 
plugins.  You will have to include your plugin dependencies in ```package.json```.

```coffeescript
config =
  plugins:
    stylus:
      plugins: ['my-stylus-plugin']
```

### Manage imports
You can import your modules or Stylus sheets with a config directive
`config.plugins.stylus.imports` (array) with paths to your modules.

```coffeescript
config =
  plugins:
    stylus:
      imports: ['']
```

### Debugging
Enable line number comments or FireStylus for Firebug debug messages (both are off by default)

```coffeescript
config =
  plugins:
    stylus:
      linenos: yes
      firebug: yes      
```

## License
The MIT License (MIT)

Copyright (c) 2012 Paul Miller (http://paulmillr.com/)

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the “Software”), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED “AS IS”, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.

## License

The MIT License (MIT)

Copyright (c) 2012-2013 Paul Miller (http://paulmillr.com)

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
