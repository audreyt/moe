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
  sims = ""
  for char in it
    continue unless Shape[char]
    sims += char + Shape[char]
  show-chars sims

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

window.debug = function show-chars
  window.table = table = []
  for ch in it
    continue unless Sound[ch]
    radical = Radical[ch]
    bpmf = Sound[ch].0
    table.push { ch, bpmf, radical }
  window.init table
  window.animate!

function go-radical
  show-chars RadicalSame[ it ]

function go-rhyme
  show-chars SoundRhyme[ (it - /[ˋˊˇ‧]/g)[*-1] ]

function go-alike
  show-chars SoundAlike[ (it - /[ˋˊˇ‧]/g) ]

table <- GET "Table.json"
window.table = table
window.init table
window.animate!
