<- $

origin = "http://127.0.0.1:8888/"
@frames = []
for x in $('iframe').get! => @frames.push x.contentWindow.window

window.id = \hub
window.reset = -> input ''
window.addEventListener("message", -> window.input it.data, false);
window.input = ->
  for w in @frames => w.postMessage it, origin
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
