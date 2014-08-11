gulp                   = require 'gulp'
gutil                  = require 'gulp-util'
coffee                 = require 'gulp-coffee'
stylus                 = require 'gulp-stylus'
concat                 = require 'gulp-concat'
notify                 = require 'gulp-notify'
browserify             = require 'gulp-browserify'
sourcemaps             = require 'gulp-sourcemaps'
jade                   = require 'gulp-jade'
plumber                = require 'gulp-plumber'
lazypipe               = require 'lazypipe'
nib                    = require 'nib'
jeet                   = require 'jeet'
{reload} = browsersync = require 'browser-sync'

onerr = lazypipe()
  .pipe(plumber, errorHandler: notify.onError "Error: <%= error.message %>")

gulp.task 'templates', ->
  gulp.src('src/**/*.jade')
  .pipe onerr()
  .pipe jade pretty: true
  .pipe gulp.dest('bin/')

gulp.task 'scripts', ->
  gulp.src('src/js/**/*.coffee')
  .pipe onerr()
  .pipe sourcemaps.init()
  .pipe coffee()
  .pipe gulp.dest('build/js')

gulp.task 'modules', ->
  gulp.src('build/js/*.js')
  .pipe onerr()
  .pipe browserify(debug: yes)
  .pipe concat('app.js')
  .pipe sourcemaps.write()
  .pipe gulp.dest('bin/js')
  .pipe notify('Wrote file file: <%= file.relative %>')

gulp.task 'styles', ->
  gulp.src('src/css/app.styl')
  .pipe onerr()
  .pipe stylus set: ['compress'], use: [nib(), jeet()]
  .pipe gulp.dest 'bin/css'
  .pipe reload(stream: yes)

gulp.task 'watch', ->
  gulp.watch('src/js/**/*.coffee', ['scripts'])
  gulp.watch('build/js/**/*.js', ['modules', reload])
  gulp.watch('src/**/*.jade', ['templates', reload])
  gulp.watch('src/css/**/*.styl', ['styles'])

gulp.task 'server', ->
  browsersync
    server: 'bin/'
    notify: true

gulp.task 'default',
  ['server', 'watch', 'scripts', 'templates', 'styles']
