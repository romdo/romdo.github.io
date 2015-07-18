class Routes extends Backbone.Router
  routes:
    ""     : "index"
    "*url" : "showPage"

  initialize: ->
    @pages = new PageContentView(el: $("#page-content"))

  index: =>
    console.log "showing: /"
    @pages.showList()

  showPage: (url) =>
    console.log "showing: /#{url}"
    @pages.showPage(url)
