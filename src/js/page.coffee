{ View, $$, $ } = require 'space-pen'

module.exports =
class Page extends View
  @content: (params) ->
    @h1 params.title
  initialize: ->
    console.log 'hey from pagsse yoolo'
  beforeRemove: ->
    console.log 'see yazzss'
