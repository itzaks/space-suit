fs                     = require 'fs'
gulp                   = require 'gulp'
gutil                  = require 'gulp-util'
coffee                 = require 'gulp-coffee'
stylus                 = require 'gulp-stylus'
concat                 = require 'gulp-concat'
notify                 = require 'gulp-notify'
jade                   = require 'gulp-jade'
plumber                = require 'gulp-plumber'
bower                  = require 'main-bower-files'
lazypipe               = require 'lazypipe'
nib                    = require 'nib'
jeet                   = require 'jeet'
nodemon                = require 'nodemon'
{reload} = browsersync = require 'browser-sync'

onerror = lazypipe().pipe(plumber, errorHandler:
  notify.onError "Error: <%= error.message %>"
)

gulp.task 'browserify', ->
  bundler = browserify
    cache: {}, packageCache: {}, fullPaths: true,
    entries: ["./src/js/app.coffee"]
    extensions: [ ".coffee", ".jade"]
    debug: yes

  bundler.transform(coffeeify).transform(jadeify)

  bundler = watchify(bundler)
  bundler.on 'update', bundle = ->
    bundler.bundle()
    .pipe onerror()
    .pipe source("app.js")
    .pipe notify('Wrote file file: <%= file.relative %>')
    .pipe reload(stream: yes)
    .pipe gulp.dest("./bin/js")
  bundle()

gulp.task 'styles', ->
  gulp.src('src/css/app.styl')
  .pipe onerror()
  .pipe stylus set: ['compress'], use: [nib(), jeet()]
  .pipe gulp.dest 'bin/css'
  .pipe reload stream: yes

gulp.task 'vendor_scripts', ->
  files = bower(filter: /\.js$/i)
  files.push 'app/js/vendor/*.js'
  gulp.src files
  .pipe concat 'vendor.js'
  .pipe notify 'Wrote file file: <%= file.relative %>'
  .pipe gulp.dest 'bin/js'

gulp.task 'bower_css', ->
  gulp.src(bower(filter: /\.css$/i))
  .pipe concat('vendor.css')
  .pipe gulp.dest 'bin/css'

gulp.task 'assets', ->
  gulp.src(['src/assets/**/*', 'src/clients/**/*.png'])
  .pipe gulp.dest 'bin/assets/'

gulp.task 'markup', ->
  gulp.src('src/index.jade')
  .pipe onerror()
  .pipe jade pretty: true
  .pipe gulp.dest('bin/')

gulp.task 'watch', ['browserify'], ->
  gulp.watch('src/assets/**/*', ['assets'])
  gulp.watch('src/css/**/*.styl', ['styles'])
  gulp.watch('src/index.jade', ['markup', reload])

gulp.task 'nodemon', (next) ->
  nodemon {script: 'server.coffee', watch: 'server.coffee'}
  .on 'restart', -> reload()
  .once 'start', -> setTimeout next, 500

gulp.task 'server', ['nodemon'], ->
  browsersync
    notify: no
    proxy: 'http://localhost:3001'
    port: 3000

gulp.task 'bower', ['vendor_scripts', 'bower_css']
gulp.task 'app', ['styles', 'markup', 'assets']
gulp.task 'default', ['server', 'watch', 'bower', 'app']
