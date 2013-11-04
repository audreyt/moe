<- $

origin = "http://direct.moedict.tw/"
frames = []
for x in $('iframe').get! => frames.push x.contentWindow.window

prev = \明
window.id = \hub
window.reset = -> input ''
#window.addEventListener("message", -> window.input it.data, false);
window.post = function post (text, origin)
  return if text is /^[-a-zA-Z\s]*$/

  return if $(".project-#origin > .tube-status").hasClass \close
  return if "#prev" is "#text"
  prev := text
  window.push-text? text, origin
  for w in frames | w.id isnt origin
    unless $(".project-#{w.id} > .tube-status").hasClass \close => let w
      <- window.requestAnimationFrame
      <- setTimeout _, 1000ms
      w.input? prev, origin
window.output = ->
  # record?

CACHED = {}
GET = (url, data, onSuccess, dataType) ->
  if data instanceof Function
    [data, dataType, onSuccess] = [null, onSuccess, data]
  return onSuccess(CACHED[url]) if CACHED[url]
  $.get(url, data, (->
    onSuccess(CACHED[url] = it)
  ), (dataType || \json)).fail ->
    #x = decodeURIComponent(url) - /\.json$/ - /^\w/
    #window.input x
