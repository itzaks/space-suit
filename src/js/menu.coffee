{ View } = require 'space-pen'
pages = require('./lib/pages')

module.exports =
class Menu extends View
  @content: (params) ->
    @nav class: 'menu', => for url in pages
      @a class: 'menu-item', click: 'click', href: "/#{ url }", url

  click: (event, element) =>
    @find('.is-active').removeClass 'is-active'
    element.addClass 'is-active'
