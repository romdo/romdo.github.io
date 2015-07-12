class Episodes extends Backbone.Collection
  model: Episode
  url: window.rssPath

  comparator: (a, b) ->
    if a.get("pubDateMoment").isAfter(b.get("pubDateMoment"))
      -1
    else if a.get("pubDateMoment").isBefore(b.get("pubDateMoment"))
      1
    else if a.get("pubDateMoment").isSame(b.get("pubDateMoment"))
      0

  fetch: (options) =>
    options ||= {}
    options.dataType = 'xml'
    Backbone.Collection.prototype.fetch.call(this, options)

  parse: (data) =>
    parsed = []
    $(data).find('item').each (_, elm) => parsed.push(@_parseItem(elm))
    parsed

  _parseItem: (elm) ->
    elm = $(elm)

    guidFull  = elm.find('guid').text()
    guid      = guidFull.replace(/^.*\:tracks\/(\d+)$/, "$1")
    link      = elm.find("link").text()
    slug      = link.replace(/.*\/(.+?)$/, "$1")
    pubDate   = elm.find("pubDate").text()
    enclosure = elm.find("enclosure")

    pubDateFormat = "D MMM YYYY HH:mm:ss ZZ"
    pubDateMoment = moment(pubDate, pubDateFormat)

    {
      id: slug
      guid: guid
      title: elm.find("title").text()
      pubDate: pubDate
      pubDateMoment: pubDateMoment
      slug: slug
      link: link
      duration: elm.find("duration").text()
      summary: elm.find("summary").text()
      subtitle: elm.find("subtitle").text()
      description: elm.find("description").text()
      image_url: elm.find("image").attr("href")
      media_url: enclosure.attr("url")
      media_length: enclosure.attr("length")
    }
