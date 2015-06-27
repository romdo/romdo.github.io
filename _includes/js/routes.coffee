class Routes extends Backbone.Router
  routes:
    ""      : "index"
    ":slug" : "showEpisode"

  initialize: ->
    @episodes = new Episodes(url: window.rssPath)
    @episodes.fetch()
    @listView = new EpisodeListView
      el: $("#episode_list")
      collection: @episodes

  index: =>

  showEpisode: (slug) =>
    console.log "showEpisode:", slug
