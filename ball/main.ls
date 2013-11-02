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
Sound <- GET "Sound.json"
Radical <- GET "Radical.json"
Rhyme <- GET "SoundRhyme.json"

origin = "http://127.0.0.1:8888/"
window.id = \tmuse
window.reset = -> $in.val ''
window.addEventListener("message", -> window.input it.data, false);
window.input = ->
  $in.val it
  $out.empty!
  function x => it - /[`~]/g
  for char in it
    continue unless Shape[char]
    for ch in char + Shape[char] => let ch
      console.log ch
      parts = []
      parts.push $(\<a/> href: \#).text(ch).click -> window.output $(@).text! # 字形
      for s in Sound[ch] || []
        parts.push $(\<a/> href: \#).text(s).click -> go-rhyme $(@).text! # 字音
      parts.push $(\<a/> href: \#).text(Radical[ch]).click -> go-radical $(@).text! # 部首
      $li = $(\<li/>)
      for p in parts
        $li.append( p )
        $li.append( '&nbsp;' )
      $li.appendTo $out

window.output = ->
  return if window.muted
  input it
  window.top.postMessage(it, origin)

function go-radical
  # ch <- GET "c/@label.json"
  return

function go-rhyme
  # ch <- GET "a/@label.json"
  return

