#window ?= -> { $: require(\jquery), addEventListener: -> }
Array::powerset = String::powerset = ->
  return @ if @length <= 1
  xs = Array::slice.call @
  x = Array::pop.call xs
  p = xs.powerset!
  p.concat p.map -> it.concat [x]
String::permutate = ->
  return @ if @length is 1
  ret = []
  xs = @substr 1
  x = @.0
  p = xs.permutate!
  for set in p
    for i from 0 to set.length
      before = set.substring 0, i
      after = set.substring i
      ret.push before + x + after
  ret
# global
origin = "http://127.0.0.1:8888/"
buffer = []
$input = $ \#input
$output = $ \#output
# functions to handle message event
buffer = []
var CharComp
var CompChar
var OrigChars
msg-before-data = ({data}) ->
  buffer.push data
msg-after-data = ({data}) ->
  data = ($input.val! + data)
  $input.val data
  comps = []
  get-comps = ->
    out = ""
    return out if it.length <= 0
    for char in it
      comps = CharComp[char]
      out += comps if comps
    it + get-comps out
  comps = get-comps data
  foo = {}
  for part in (comps / '').sort! =>
    foo[part] = true
  comps = Object.keys(foo).sort! * ''
  seen = {}
  for ch in comps => seen[ch] = true if ch in OrigChars
  scanned = { '' : true }
  scanl = (taken, rest) ->
    unless scanned[taken]
      scanned[taken] = true
      c = CompChar[taken]
      seen[c] = true if c and c in OrigChars
    return if rest.length == 0
    head = rest.0
    rest.=substr(1)
    scanl taken, rest
    scanl taken + head, rest
  scanl '', comps
  keys = Object.keys(seen)
  $output.empty!
  for char in keys
    $output.append($(\<li/>).append $(\<a/> href: \#).text char .click ->
      window.output $(@).text!
    )
  JSON.stringify keys,, 2
# API
window.id = \lhc
window.reset = -> $input.val ""
window.input = -> msg-before-data {data: it}
window.addEventListener \message msg-before-data
window.output = ->
  return if window.muted
  window.top.postMessage it, origin
# load char to comps and comps to char table
d <- $.get \./data/char_comp_simple.json
CharComp := d
d <- $.get \./data/comp_char_sorted.json
CompChar := d
d <- $.get \./data/orig-chars.json
OrigChars := d
window.input := -> msg-after-data {data: it}
window.removeEventListener \message, msg-before-data
for data in buffer
  msg-after-data {data}
window.addEventListener \message, msg-after-data

