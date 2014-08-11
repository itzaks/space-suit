{ $ } = require 'space-pen'
lasso = require 'lasso-js'
page = require 'page'

do ->
  $(document).on "click", "a[href^='/']", (event) ->
    $link = $(event.currentTarget)
    href = $link.attr('href')
    # chain 'or's for other black list routes
    passThrough = $link.attr("target") is '_blank'

    # Allow shift+click for new tabs, etc.
    if !passThrough && !event.altKey && !event.ctrlKey && !event.metaKey && !event.shiftKey
      event.preventDefault()

      # Remove leading slashes and hash bangs (backward compatablility)
      url = href.replace(/^\//,'').replace('\#\!\/','')

      # Instruct Backbone to trigger routing events
      lasso.broadcast 'route', url
      page(url)

      return false
