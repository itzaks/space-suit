{ View, $$, $ } = require 'space-pen'

module.exports =
class Page extends View
  initialize: (params) ->
    {@title} = params

  @content: (params) ->
    @h2 outlet: 'title', params.title

  afterAttach: (has_dom) ->
    if has_dom
      console.log "With CSS applied, my height is", @height()

  beforeRemove: ->
    console.log "#{ @title } left the building!"
