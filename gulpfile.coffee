require('dotenv').load()

bower                  = require 'main-bower-files'
browserify             = require 'browserify'
coffee                 = require 'gulp-coffee'
coffeeify              = require 'coffeeify'
concat                 = require 'gulp-concat'
del                    = require 'del'
fs                     = require 'fs'
gulp                   = require 'gulp'
gutil                  = require 'gulp-util'
jade                   = require 'gulp-jade'
jadeify                = require 'jadeify'
jeet                   = require 'jeet'
lazypipe               = require 'lazypipe'
nib                    = require 'nib'
nodemon                = require 'nodemon'
notify                 = require 'gulp-notify'
plumber                = require 'gulp-plumber'
source                 = require 'vinyl-source-stream'
stylus                 = require 'gulp-stylus'
uglify                 = require 'gulp-uglify'
uglifyify              = require 'uglifyify'
watchify               = require 'watchify'
{reload} = browsersync = require 'browser-sync'

PRODUCTION = process.env.NODE_ENV is 'production'
WATCH      = no

onerror =
  lazypipe()
  .pipe plumber, errorHandler: notify.onError "Error: <%= error.message %>"

gulp.task 'browserify', ->
  bundler = browserify
    cache      : {}, packageCache: {}, fullPaths: true,
    entries    : ["./src/js/app.coffee"]
    extensions : [ ".coffee", ".jade"]
    debug      : !PRODUCTION

  bundler
  .transform(coffeeify)
  .transform(jadeify)

  if PRODUCTION
    bundler.transform global: on, 'uglifyify'

  bundle = ->
    bundler.bundle()
    .pipe onerror()
    .pipe source("app.js")
    .pipe notify('Wrote file file: <%= file.relative %>')
    .pipe reload(stream: yes)
    .pipe gulp.dest("./bin/js")

  if WATCH
    bundler = watchify(bundler)
    bundler.on 'update', bundle

  bundle()

gulp.task 'styles', ->
  gulp.src('src/css/app.styl')
  .pipe onerror()
  .pipe stylus set: ['compress'], use: [nib(), jeet()]
  .pipe gulp.dest 'bin/css'
  .pipe reload stream: yes

gulp.task 'vendor_scripts', ->
  files = bower(filter: /\.js$/i)
  files.push 'src/js/vendor/*.js'
  gulp.src files
  .pipe concat 'vendor.js'
  .pipe uglify()
  .pipe notify 'Wrote file file: <%= file.relative %>'
  .pipe gulp.dest 'bin/js'

gulp.task 'bower_css', ->
  gulp.src(bower(filter: /\.css$/i))
  .pipe concat('vendor.css')
  .pipe gulp.dest 'bin/css'

gulp.task 'bower_assets', ->
  gulp.src(bower(filter: /.*\.(?!js|css).*/i))
  .pipe gulp.dest 'bin/'

gulp.task 'copy_assets', ->
  gulp.src(['src/assets/**/*'])
  .pipe gulp.dest 'bin/assets/'

gulp.task 'clean', (cb) -> del ['bin'], cb

# Generate index.html
gulp.task 'markup', ->
  gulp.src('src/index.jade')
  .pipe onerror()
  .pipe jade pretty: true
  .pipe gulp.dest('bin/')

# Server watch
gulp.task 'nodemon', (next) ->
  nodemon script: 'server/index.coffee', watch: ['server/']
  .on 'restart', -> console.log 'server:restarted'; reload()
  .once 'start', -> setTimeout next, 500

gulp.task 'server', ['nodemon'], ->
  browsersync
    notify: no
    proxy: 'http://localhost:3001'
    port: 3000

gulp.task 'watch_on', -> WATCH = on
gulp.task 'watch_off', -> WATCH = off

# Watch and build
gulp.task 'watch', ['watch_on', 'browserify'], ->
  gulp.watch 'src/assets/**/*',       ['copy_assets',      reload]
  gulp.watch 'src/clients/**/*.png',  ['copy_assets',      reload]
  gulp.watch 'src/index.jade',        ['markup',           reload]
  gulp.watch 'src/clients/**/*.jade', ['client_templates', reload]
  gulp.watch 'src/clients/**/*.styl', ['client_styles']
  gulp.watch 'src/css/**/*.styl',     ['styles']

gulp.task 'client',   ['client_styles', 'client_templates']
gulp.task 'bower',    ['vendor_scripts', 'bower_css', 'bower_assets']
gulp.task 'app',      ['styles', 'markup', 'copy_assets']
gulp.task 'build',    ['watch_off', 'browserify', 'bower', 'client', 'app']
gulp.task 'default',  ['server', 'watch', 'bower', 'client', 'app']
