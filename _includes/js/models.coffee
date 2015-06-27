class Episode extends Backbone.Model

  formattedDate: =>
    format = "D MMM YYYY HH:mm:ss ZZ"
    moment(@get("pubDate"), format).format('MMMM Do, YYYY')

  description: =>
    @get("description").replace(/\n/g, "<br />")

  summary: =>
    @get("description").replace("\n", "")
