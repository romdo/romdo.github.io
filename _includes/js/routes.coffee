class Routes extends Backbone.Router
  routes:
    ""    : "index"
    ":id" : "showEpisode"

  initialize: ->
    @episodes = new Episodes(url: window.rssPath)
    @episodes.fetch(success: @initializeList)

  initializeList: =>
    @listView = new EpisodeListView
      el: $("#episode_list")
      collection: @episodes
    @listView.render()

    if @defaultAction
      if @defaultAction.length == 1
        @listView[@defaultAction[0]]()
      else if @defaultAction.length == 2
        @listView[@defaultAction[0]](@defaultAction[1]...)

  index: =>
    if @listView
      @listView.showAll()
    else
      @defaultAction = ["showAll"]

  showEpisode: (id) =>
    if @listView
      @listView.showId(id)
    else
      @defaultAction = ["showId", [id]]
