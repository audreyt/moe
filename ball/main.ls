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

origin = "http://direct.moedict.tw/"
window.id = \ball
window.reset = -> $in.val ''
window.addEventListener("message", -> window.input it.data, false);
window.input = (ch) ->
  return unless ch and Sound[ch.0]
  $in.val ch
  $out.empty!
  ch = ch.0 if ch.length > 1
  window.show-all { ch, bpmf: Sound[ch]?0, radical: Radical[ch] }

window.output = ->
  return if window.muted
  window.parent.post? it, window.id

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
    bpmfs = Sound[ch]
    table.push { ch, bpmfs, radical }
  window.init table
  window.animate!

window.show-chars = function show-chars (chars)
  return unless chars
  return if window.location is "?#{ encodeURIComponent chars }"
  return if window.location is "?#chars"
  window.location.href = window.location.pathname + "?#{ encodeURIComponent chars }"

function go-radical
  show-chars RadicalSame[ it ]

function go-rhyme
  show-chars SoundRhyme[ (it - /[ˋˊˇ‧]/g)[*-1] ]

function go-alike
  show-chars SoundAlike[ (it - /[ˋˊˇ‧]/g) ]

window.uniq = uniq = ->
  seen = {}
  out = ''
  for w in it / ''
    out += w unless seen[w]
    seen[w] = true
  return out

window.go-char = function go-char ({ch, bpmf, radical})
  output ch if ch
  <- setTimeout _, 1ms
  window.show-all {ch, bpmf, radical}

window.show-all = function show-all ({ch='', bpmf, radical})
  sims = snds = rads = ''
  sims = go-similar(ch) || '' if ch
  snds = SoundAlike[ (bpmf - /[ˋˊˇ‧]/g) ] || '' if bpmf
  rads = RadicalSame[ radical ] || '' if radical
  sims = sims.slice(0, 50) if sims.length > 50
  snds = snds.slice(0, 50) if snds.length > 50
  all = uniq(ch + sims + snds + rads)
  all = all.slice(0, 100) if all.length > 100
  show-chars all

window.go-similar = function go-similar
  sims = ""
  for char in it
    continue unless Shape[char]
    sims += char + Shape[char]
  return sims

if "#{ location.search }" is /[^?]/
  <- setTimeout _, 1ms
  render-chars("#{ decodeURIComponent location.search }")
else
  <- setTimeout _, 1ms
  render-chars("萌夢孟懵懵朦檬氓濛猛盟盟矇矇蒙蜢錳")
  #table <- GET "Table.json"
  #window.table = table
  #window.init table
  #window.animate!
