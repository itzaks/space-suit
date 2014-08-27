{ View, $ } = require 'space-pen'
window.$ = window.jQuery = $

class App extends View
  @content: (params) ->
    @div class: 'app', =>
      @h1 '-> click <-', click: 'change_face'
      @h2 ':–)', outlet: 'smile'

  change_face: ->
    smile = [':–(', ':-o', '>:–)', ';––)', ':-)']
    pick = Math.round (Math.random() * smile.length)
    
    @smile.text smile[pick]

$ ->
  $ 'body'
  .html new App()
