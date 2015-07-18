$ ->
  window.router = new Routes()

  Backbone.history.start
    root: "/"
    pushState: true
    hashState: false

  $("#home-link").on "click", (evt) ->
    evt.preventDefault()
    router.navigate("/", trigger: true)
