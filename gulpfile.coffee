gulp                   = require 'gulp'
gutil                  = require 'gulp-util'
coffee                 = require 'gulp-coffee'
stylus                 = require 'gulp-stylus'
concat                 = require 'gulp-concat'
notify                 = require 'gulp-notify'
uglify                 = require 'gulp-uglify'
browserify             = require 'gulp-browserify'
sourcemaps             = require 'gulp-sourcemaps'
jade                   = require 'gulp-jade'
plumber                = require 'gulp-plumber'
bower                  = require 'main-bower-files'
lazypipe               = require 'lazypipe'
nib                    = require 'nib'
jeet                   = require 'jeet'
del                    = require 'del'
{reload} = browsersync = require 'browser-sync'

onerror = lazypipe()
  .pipe(plumber, errorHandler:
    notify.onError "Error: <%= error.message %>"
  )

gulp.task 'templates', ->
  gulp.src('src/**/*.jade')
  .pipe onerror()
  .pipe jade pretty: true
  .pipe gulp.dest('bin/')

gulp.task 'scripts', ->
  gulp.src('src/js/**/*.coffee')
  .pipe onerror()
  .pipe sourcemaps.init()
  .pipe coffee()
  .pipe gulp.dest('build/js')

gulp.task 'modules', ->
  gulp.src('build/js/*.js')
  .pipe onerror()
  .pipe browserify(debug: yes)
  .pipe concat('app.js')
  .pipe sourcemaps.write()
  .pipe gulp.dest('bin/js')
  .pipe notify('Wrote file file: <%= file.relative %>')

gulp.task 'styles', ->
  gulp.src('src/css/app.styl')
  .pipe onerror()
  .pipe stylus set: ['compress'], use: [nib(), jeet()]
  .pipe gulp.dest 'bin/css'
  .pipe reload stream: yes

gulp.task 'bower_js', ->
  gulp.src bower(filter: /\.js$/i)
  .pipe concat('vendor.js')
  .pipe uglify()
  .pipe gulp.dest 'bin/js'

gulp.task 'bower_css', ->
  gulp.src(bower(filter: /\.css$/i))
  .pipe concat('vendor.css')
  .pipe gulp.dest 'bin/css'

gulp.task 'watch', ->
  gulp.watch('src/js/**/*.coffee', ['scripts'])
  gulp.watch('build/js/**/*.js', ['modules', reload])
  gulp.watch('src/**/*.jade', ['templates', reload])
  gulp.watch('src/css/**/*.styl', ['styles'])

gulp.task 'clean', (cb) -> del ['build', 'bin']; cb()
gulp.task 'bower', ['bower_js', 'bower_css']
gulp.task 'server', -> browsersync(server: 'bin/', notify: no)
gulp.task 'client', ['bower', 'scripts', 'templates', 'styles']
gulp.task 'default', ['clean', 'server', 'watch', 'client']
