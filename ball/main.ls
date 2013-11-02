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
RadicalSame <- GET "RadicalSame.json"
SoundRhyme <- GET "SoundRhyme.json"
SoundAlike <- GET "SoundAlike.json"

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
    for ch in char + Shape[char] => draw ch

window.output = ->
  return if window.muted
  input it
  window.top.postMessage(it, origin)

function draw (ch)
  parts = []
  parts.push $(\<a/> href: \#).text(ch).click -> window.output $(@).text! # 字形
  for s in Sound[ch] || []
    #parts.push $(\<a/> href: \#).text(s).click -> go-rhyme $(@).text! # 字音
    parts.push $(\<a/> href: \#).text(s).click -> go-alike $(@).text! # 字音
  parts.push $(\<a/> href: \#).text(Radical[ch]).click -> go-radical $(@).text! # 部首
  $li = $(\<li/>)
  for p in parts
    $li.append( p )
    $li.append( '&nbsp;' )
  $li.appendTo $out

function go-radical
  $out.empty!
  for ch in RadicalSame[ it ] => draw ch
  return

function go-rhyme
  $out.empty!
  for ch in SoundRhyme[ (it - /[ˋˊˇ‧]/g)[*-1] ] => draw ch

function go-alike
  $out.empty!
  for ch in SoundAlike[ (it - /[ˋˊˇ‧]/g) ] => draw ch

table <- GET "Table.json"
window.init(table);
window.animate();
