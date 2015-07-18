class PageContentView extends Backbone.View
  className: "page-content"

  initialize: ->
    @firstAction  = true
    @children     = []
    @collection   = new Pages()
    @currentIndex = 0
    window.pages  = @collection # for debugging purposes

    @listenTo(@collection, "add", @addOne)

    @collection.parseElm(@$el)

  showList: =>
    # If first action is showList, we've already got all via parsing the
    # current page.
    if @firstAction
      @fetchedAll  = true
      @currentPage = "/"
      @firstAction = false

    return if @currentPage == "/"

    showAll = =>
      for child in @children
        if child.model.id != @currentPage
          if @currentChild?.model.get("index") > child.model.get("index")
            child.prependTo(@$el)
          else
            child.appendTo(@$el)
        else
          child.unfocussed()

      @currentPage = "/"

    if !@fetchedAll
      @collection.fetchMissing(success: showAll)
      @fetchedAll = true
    else
      showAll()

  showPage: (url) =>
    showView = =>
      for child in @children
        if child.model.id == url
          child.appendTo(@$el) unless child.onPage
          child.focussed()
          @currentChild = child
        else
          child.remove()
          child.unfocussed()

    if @currentPage != url
      if !@collection.get(url)
        @collection.fetchSpecific("/#{url}", success: showView)
      else
        showView()

    @currentPage = url
    @firstAction = false

  addOne: (model) =>
    child = new PageView
      model: model
      el: model.get("elm")

    @children.push(child)


class PageView extends Backbone.View

  initialize: ->
    @onPage = $.contains(document.documentElement, @$el.get(0))

    @titleLink            = @$(".title a")
    @readMoreLink         = @$(".toggle-more a.more")
    @descriptionContainer = @$(".description")
    @descriptionContent   = @$(".description-content")

    @initLinks()

  initLinks: =>
    @titleLink.on("click", @navigateToSelf)
    @readMoreLink.on("click", @navigateToSelf)

  stopListening: =>
    @titleLink.off("click", @navigateToSelf)
    @readMoreLink.off("click", @navigateToSelf)
    super

  remove: =>
    @onPage = false
    super

  prependTo: (elm) =>
    $(elm).prepend(@el)
    @onPage = true
    @initLinks()

  appendTo: (elm) =>
    $(elm).append(@el)
    @onPage = true
    @initLinks()

  navigateToSelf: (evt) =>
    evt.preventDefault()
    window.router.navigate(@model.id, trigger: true)

  focussed: =>
    @expandDescription()
    $("head title").text(@model.get("title"))
    window.scrollTo(0, 0)

  unfocussed: =>
    $("head title").text("romdo")
    @collapseDescription()

  expandDescription: =>
    if @descriptionContainer.height() >= @descriptionContent.height()
      @descriptionContainer.css("max-height": @descriptionContent.height())
    else
      @descriptionContainer.velocity
        properties: {"max-height": @descriptionContent.height()}
        options:
          duration: 400
          complete: =>
            @$el.removeClass("in-list")
            @$('.toggle-more').hide()

  collapseDescription: =>
    if @descriptionContainer.height() == 230
      @descriptionContainer.css("max-height": "230px")
    else
      @$('.toggle-more').show()
      @descriptionContainer.velocity
        properties: {"max-height": "230px"}
        options:
          duration: 100
          complete: => @$el.addClass("in-list")
