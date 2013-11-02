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
  show-chars go-similar it
  $out.empty!

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

window.render-chars = function render-chars
  window.table = table = []
  for ch in it
    # console.log ch
    continue unless Sound[ch]
    radical = Radical[ch]
    bpmf = Sound[ch].0
    table.push { ch, bpmf, radical }
  window.init table
  window.animate!

window.show-chars = function show-chars
  window.location ="?#{ encodeURIComponent it }"

function go-radical
  show-chars RadicalSame[ it ]

function go-rhyme
  show-chars SoundRhyme[ (it - /[ˋˊˇ‧]/g)[*-1] ]

function go-alike
  show-chars SoundAlike[ (it - /[ˋˊˇ‧]/g) ]

window.go-char = function go-char ({ch, bpmf, radical})
  output ch
  <- setTimeout _, 1ms
  rads = RadicalSame[ radical ] || ''
  snds = SoundAlike[ bpmf ] || ''
  sims = go-similar(ch) || ''
  # console.log rads+snds+sims
  show-chars(rads+snds+sims)

window.go-similar = function go-similar
  sims = ""
  for char in it
    continue unless Shape[char]
    sims += char + Shape[char]
  return sims

if location.search
  <- setTimeout _, 1ms
  render-chars("#{ decodeURIComponent location.search }")
else
  table <- GET "Table.json"
  window.table = table
  window.init table
  window.animate!
