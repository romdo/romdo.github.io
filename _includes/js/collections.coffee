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

    guid      = elm.find('guid').text()
    link      = elm.find("link").text()
    enclosure = elm.find("enclosure")
    {
      id: guid.replace(/^.*\:tracks\/(\d+)$/, "$1")
      guid: guid
      title: elm.find("title").text()
      pubDate: elm.find("pubDate").text()
      slug: link.replace(/.*\/(.+?)$/, "$1")
      link: link
      duration: elm.find("duration").text()
      summary: elm.find("summary").text()
      subtitle: elm.find("subtitle").text()
      description: elm.find("description").text()
      image_url: elm.find("image").attr("href")
      media_url: enclosure.attr("url")
      media_length: enclosure.attr("length")
    }
