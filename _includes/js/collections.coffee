class Pages extends Backbone.Collection
  model: Page
  url: "/index.html"

  initialize: (options) =>
    @url = options.url if options?.url

  comparator: (model) ->
    model.get("index")

  fetch: (options) =>
    options ||= {}
    options.dataType = 'html'
    Backbone.Collection.prototype.fetch.call(this, options)

  fetchSpecific: (url, options) =>
    originalSuccess = options?.success

    success = (collection) =>
      collection.each (page) =>
        existing = @get(page.id)
        if !existing
          @add(page)
        else
          existing.set(index: page.get("index"))

      # Manually trigger a sort in case we've changed the existing models'
      # index value.
      @sort()

      if originalSuccess && typeof originalSuccess == "function"
        originalSuccess(arguments)

    fetcher = new @constructor(url: url)
    fetcher.fetch(_.extend({}, options, {success: success}))

  fetchMissing: (options) =>
    @fetchSpecific(@url, options)

  parse: (data) =>
    parsed = []
    $(data).find('.page').each (i, elm) =>
      parsed.push(@_parseItem(elm, i))

    parsed

  parseElm: (elm) =>
    parsed = []

    $(elm).find('.page').each (i, elm) =>
      parsed.push(@_parseItem(elm, i))

    @set(parsed)

  _parseItem: (elm, index) ->
    elm = $(elm)

    id = elm.data("pageUrl")
    id = id[1..-1] if id[0..0] == "/"

    {
      id: id
      elm: elm
      index: index + 1
    }

  indexDebug: =>
    @each (page) ->
      console.log "#{page.get('index')}: #{page.id}"
