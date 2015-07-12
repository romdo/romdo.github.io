class EpisodeListView extends Support.CompositeView
  className: "episode-list"

  initialize: (options) ->
    @showing = null

    @collection.on "add", @addOne
    @collection.on "reset", @addAll
    @collection.on "remove", @removeOne

  showAll: =>
    @showing = "__all"
    @_updateChildren()

  showId: (id) =>
    @showing = id
    @_updateChildren()

  render: =>
    @addAll()

  addAll: =>
    @collection.each (model) =>
      @addOne(model)

  addOne: (model) =>
    view = new EpisodeView(model: model)
    @appendChild(view)

  removeOne: (model) =>
    return if @children.isEmpty()

    view = @children.find (child) ->
      child.model?.get("id") == model.get("id")

    view.leave() if view?

  _updateChildren: =>
    @children.each (child) -> child.render()


class EpisodeView extends Support.CompositeView
  className: "episode-item"
  template: (variables) =>
    @cachedTemplate ||= _.template($("#episode_item").html())
    @cachedTemplate(variables)

  render: =>
    showAll  = @parent.showing == "__all"
    showSelf = @parent.showing == @model.id

    if !@rendered && (showAll || showSelf)
      @$el.html(@template(model: @model))
      @descriptionContainer = @$(".description")
      @descriptionContent   = @$(".description-content")

      setTimeout @renderShowMore, 1
      @rendered = true

    if showAll
      @$el.show()
      setTimeout @collapseDescription, 1
    else if showSelf
      @$el.show()
      setTimeout @expandDescription, 1
    else
      @$el.hide()

  renderShowMore: =>
    return if @descriptionContainer.height() >= @descriptionContent.height()
    @$(".toggle-more").show()

  expandDescription: =>
    return if @descriptionContainer.height() >= @descriptionContent.height()

    @descriptionContainer.velocity
      "max-height": @descriptionContent.height()
      complete: =>
        @$(".toggle-more .more, .toggle-more .fade").hide()

  collapseDescription: =>
    return if @descriptionContainer.height() == 230

    @descriptionContainer.velocity
      "max-height": "230px"
      complete: =>
        @$(".toggle-more .more, .toggle-more .fade").show()
