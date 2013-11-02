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
window.uniq = uniq = ->
  seen = {}
  for w in it / '' => seen[w] = true
  Object.keys(seen).sort! * ''
msg-after-data = ({data}) ->
  data = uniq($input.val! + data)
  $input.val data
  comps = []
  get-comps = ->
    out = ""
    return out if it.length <= 0
    for char in it
      comps = CharComp[char]
      out += comps if comps
    it + get-comps out
  comps = uniq(get-comps data)
  seen = {}
  for ch in comps => seen[ch] = true if ch in OrigChars
  scanned = { '' : true }
  queue = []
  callback = null
  queue = [['', comps]]
  count = 0
  while queue.length
    break if count++ > 1000 # TODO: move to worker
    [taken, rest] = queue.shift!
    unless scanned[taken]
      scanned[taken] = true
      c = CompChar[taken]
      seen[c] = true if c and c in OrigChars
    break if rest.length == 0
    head = rest.0
    rest.=substr(1)
    queue.push [taken, rest]
    queue.push [taken + head, rest]
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

