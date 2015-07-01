class Routes extends Backbone.Router
  routes:
    ""    : "index"
    # ":id" : "showEpisode"

  initialize: ->
    @episodes = new Episodes(url: window.rssPath)
    @episodes.fetch()
    @listView = new EpisodeListView
      el: $("#episode_list")
      collection: @episodes
    @listView.render()

  index: =>
    # @listView.unfocus()

  # showEpisode: (id) =>
  #   @listView.focus(id)
