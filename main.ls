<- $

origin = "http://direct.moedict.tw/"
@frames = []
for x in $('iframe').get! => @frames.push x.contentWindow.window

prev = \明
window.id = \hub
window.reset = -> input ''
#window.addEventListener("message", -> window.input it.data, false);
window.post = function post (text, origin)
  return if text isnt /\S/
  return if "#prev" is "#text"
  prev := text
  for w in @frames | w.id isnt origin => let w
    console.log "Posting message or not to #{ w.id }"
    #<- setTimeout _, 50ms
    #w.postMessage prev, origin
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
