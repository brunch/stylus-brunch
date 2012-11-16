## stylus-brunch
Adds [Stylus](http://learnboost.github.com/stylus/) support to
[brunch](http://brunch.io).

Also includes [nib](http://visionmedia.github.com/nib/) cross-browser mixins and [node-sprite](https://github.com/naltatis/node-sprite) for spriting.

## Config
To enable spriting add the following to your config.coffee and make sure you habe imagemagick installed
	stylus:
    	spriting: true
    	iconPath: 'images/icons'	

## Usage
Add `"stylus-brunch": "x.y.z"` to `package.json` of your brunch app.

Pick a plugin version that corresponds to your minor (y) brunch version.

If you want to use git version of plugin, add
`"stylus-brunch": "git+ssh://git@github.com:brunch/stylus-brunch.git"`.
