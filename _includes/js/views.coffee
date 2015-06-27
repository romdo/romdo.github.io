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


class EpisodeView extends Support.CompositeView
  className: "episode-item"
  template: (variables) =>
    @cachedTemplate ||= _.template($("#episode_item").html())
    @cachedTemplate(variables)

  render: =>
    @$el.html(@template(model: @model))
    this
