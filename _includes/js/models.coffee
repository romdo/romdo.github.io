class Episode extends Backbone.Model

  formattedDate: =>
    format = "D MMM YYYY HH:mm:ss ZZ"
    moment(@get("pubDate"), format).format('MMMM Do, YYYY')

  description: =>
    @_autolink(@get("description").replace(/\n/g, "<br />"))

  summary: =>
    @get("description").replace("\n", "")

  _autolink: (str) =>
    @cachedAutolinker ||= new Autolinker
      twitter: false
      hashtag: false
      phone: false

    @cachedAutolinker.link(str)
