{ View, $$, $ } = require 'space-pen'
lasso = require 'lasso-js'

Page = require './page'
Menu = require './menu'
require './lib/helpers'

class App extends View
  @content: (params) ->
    @div class: 'app', =>
      @subview 'menu', new Menu()
      @div {class: 'page', outlet: 'page_container'}, =>
        @h2 "Page container"

  initialize: (on_dom) ->
    page = require 'page'
    page url, @open_page for url in require('./lib/pages')
    page dispatch: no

  open_page: (context) =>
    @page_container.html new Page(title: context.pathname)

$ ->
  $ 'body'
  .html new App()
