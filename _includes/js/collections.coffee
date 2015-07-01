class Episodes extends Backbone.Collection
  model: Episode
  url: window.rssPath

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
    enclosure = elm.find("enclosure")

    {
      id: slug
      guid: guid
      title: elm.find("title").text()
      pubDate: elm.find("pubDate").text()
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
