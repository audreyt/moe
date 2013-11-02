<- $

$in = $ \#input
$out = $ \#output

origin = "http://127.0.0.1:8888/"
window.id = \tmuse
window.reset = -> $in.val ''
window.addEventListener("message", -> window.input it.data, false);
window.input = ->
  $in.val it
  {graph_json: {nodes}} <- GET "a/#it.json"
  $out.empty!
  for {label} in nodes
    $out.append($(\<li/>).append $(\<a/> href: \#).text label .click -> window.output $(@).text!)
window.output = ->
  return if window.muted
  input it
  window.top.postMessage(it, origin)

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
