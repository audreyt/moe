<- $

CACHED = {}; GET = (url, data, onSuccess, dataType) ->
  if data instanceof Function
    [data, dataType, onSuccess] = [null, onSuccess, data]
  return onSuccess(CACHED[url]) if CACHED[url]
  $.get(url, data, (->
    onSuccess(CACHED[url] = it)
  ), (dataType || \json)).fail ->
    #x = decodeURIComponent(url) - /\.json$/ - /^\w/
    #window.input x

########################################################################################

$in = $ \#input
$out = $ \#output

Shape <- GET "Shape.json"

origin = "http://127.0.0.1:8888/"
window.id = \tmuse
window.reset = -> $in.val ''
window.addEventListener("message", -> window.input it.data, false);
window.input = ->
  $in.val it
  $out.empty!
  for char in it
    continue unless Shape[char]
    for label in Shape[char]
      Shape <- GET "Shape.json"
      $out.append($(\<li/>).append(
        ($(\<a/> href: \#).text label .click -> window.output $(@).text!), # 字形
        '&nbsp;'
        ($(\<a/> href: \#).text label .click -> window.output $(@).text!), # 字音
        '&nbsp;'
        ($(\<a/> href: \#).text label .click -> window.output $(@).text!) # 部首+筆劃
      ))
window.output = ->
  return if window.muted
  input it
  window.top.postMessage(it, origin)

