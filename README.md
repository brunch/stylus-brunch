# stylus-brunch

Adds [Stylus](http://learnboost.github.com/stylus/) support to
[Brunch](http://brunch.io).

The plugin includes [nib](http://tj.github.io/nib/) cross-browser mixins.

## Usage

Install the plugin via npm with `npm install --save-dev stylus-brunch`.

Or, do manual install:

* Add `"stylus-brunch": "x.y"` to `package.json` of your brunch app.
  Pick a plugin version that corresponds to your minor (y) brunch version.
* If you want to use git version of plugin, add
`"stylus-brunch": "github:brunch/stylus-brunch"`.

## Options

**You don't need to specify any options by default.**

### Use Plugin Middleware

You can include Stylus plugins with a config directive
`config.plugins.stylus.plugins` (array) with paths to require the needed
plugins.  You will have to include your plugin dependencies in `package.json`.

```js
module.exports = {
  // ...
  plugins: {
    stylus: {
      plugins: ['my-stylus-plugin']
    }
  }
};
```

If the plugin is module based you can import a specific member as a subarray.

```js
moduls.exports = {
  // ...
  plugins: {
    stylus: {
      plugins: ['my-stylus-plugin', ['my-module-plugin', 'member']]
    }
  }
};
```

Alternatively, you can pass a function.

```js
moduls.exports = {
  // ...
  plugins: {
    stylus: {
      plugins: [require('autoprefixer-stylus')({browsers: ['last 3 versions']})]
    }
  }
};
```


### Options

You can import your modules or Stylus sheets with a config directive
`config.plugins.stylus.imports` (array) with paths to your modules.

```js
moduls.exports = {
  // ...
  plugins: {
    stylus: {
      imports: ['']
    }
  }
};
```

Allow stylus files to include plain-css partials:

```js
moduls.exports = {
  // ...
  plugins: {
    stylus: {
      includeCss: true
    }
  }
};
```

### Debugging

Enable line number comments or FireStylus for Firebug debug messages (both are off by default)

```js
moduls.exports = {
  // ...
  plugins: {
    stylus: {
      linenos: true,
      firebug: true
    }
  }
};
```

### CSS Modules

Starting Brunch `<unreleased>`, you can use CSS Modules with stylus-brunch. To enable it, change your config to:

```js
module.exports = {
  // ...
  plugins: {
    stylus: {
      modules: true
    }
  }
};
```

Then, author your styles like you normally would:

```stylus
.title
  font-size: 32px
```

And reference CSS class names by requiring the specific style into your javascript:

```js
var style = require('./title.styl');

<h1 className={style.title}>Yo</h1>
```

Note: enabling `cssModules` does so for every stylesheet in your project, so it's all-or-nothing. Even the files you don't require will be transformed into CSS modules (aka will have obfuscated class names, like turn `.title` into `._title_fdphn_1`).

## License

The MIT License (MIT)

Copyright (c) 2012-2017 Paul Miller (http://paulmillr.com)

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
