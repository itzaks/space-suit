{ View, $ } = require 'space-pen'
window.$ = window.jQuery = $
Mail = require './mail'
Sidebar = require './sidebar'

class App extends View
  @content: (params) ->
    @div class: 'app', =>
      @subview 'mail', new Mail()
      @subview 'sidebar', new Sidebar()

$ ->
  $ 'body'
  .html new App()
