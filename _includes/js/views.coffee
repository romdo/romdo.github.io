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

  events:
    "click .title a"       : "focus"
    "click .toggle-more a" : "toggleMore"

  render: =>
    @$el.html(@template(model: @model))
    setTimeout @renderShowMore, 1
    this

  renderShowMore: =>
    container = @$(".description")
    content   = @$(".description-content")

    return if container.height() >= content.height()
    @$(".toggle-more").show()

  toggleMore: (evt) =>
    evt.preventDefault()

    if @$(".toggle-more .more").is(":visible")
      @focus()
    else
      @unfocus()

  focus: =>
    window.Router.navigate(@model.get("slug"))
    return if @$(".toggle-more .less").is(":visible")

    container = @$(".description")
    content   = @$(".description-content")

    container.animate "max-height": content.height()

    @$(".toggle-more .fade").hide()
    @$(".toggle-more .more").hide()
    @$(".toggle-more .less").show()

  unfocus: =>
    window.Router.navigate("")
    return if @$(".toggle-more .more").is(":visible")

    container = @$(".description")
    @$(".toggle-more .fade").show()
    container.animate("max-height": "200px")

    @$(".toggle-more .more").show()
    @$(".toggle-more .less").hide()
