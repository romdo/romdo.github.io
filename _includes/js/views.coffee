class EpisodeListView extends Support.CompositeView
  className: "episode-list"

  initialize: (options) ->
    @collection.on "add", @addOne
    @collection.on "reset", @addAll
    @collection.on "remove", @removeOne

  addAll: =>
    @collection.each (model) => @addOne(model)

  addOne: (model) =>
    view = new EpisodeView(model: model)
    @appendChild(view)

  removeOne: (model) =>
    return if @children.isEmpty()

    view = @children.find (child) ->
      child.model?.get("id") == model.get("id")

    view.leave() if view?

  # focus: (slug) =>
  #   @activeFocus = slug

  # unfocus: =>
  #   @activeFocus = null
  #   @collection.each (model) -> model.trigger("show")


class EpisodeView extends Support.CompositeView
  className: "episode-item"
  template: (variables) =>
    @cachedTemplate ||= _.template($("#episode_item").html())
    @cachedTemplate(variables)

  render: =>
    @$el.html(@template(model: @model))

    # setTimeout @renderShowMore, 1
    this

  renderShowMore: =>
    container = @$(".description")
    content   = @$(".description-content")

    return if container.height() >= content.height()
    @$(".toggle-more").show()

  # focus: =>
  #   if slug == @model.get("slug")
  #     @$el.hide()
  #     false
  #   else
  #     true

  # show: =>
  #   @$el.show()

  # hide: =>
  #   @$el.hide()
