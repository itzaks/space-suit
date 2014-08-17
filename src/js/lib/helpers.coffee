{ $ } = require 'space-pen'
page = require 'page'

do ->
  $(document).on "click", "a[href^='/']", (event) ->
    { altKey, ctrlKey, metaKey, shiftKey, preventDefault } = event
    $link = $(event.currentTarget)
    href = $link.attr('href')
    # chain 'or's for other black list routes
    passThrough = $link.attr("target") is '_blank'

    # Allow shift+click for new tabs, etc.
    if !passThrough and !altKey and !ctrlKey and !metaKey and !shiftKey
      preventDefault()

      # Remove leading slashes and hash bangs (backward compatablility)
      url = href.replace(/^\//,'').replace('\#\!\/','')

      # Instruct page to trigger routing events
      page(url)

      return false
