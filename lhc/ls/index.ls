window ?= { $: require(\jquery), addEventListener: -> }
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
my-input = ""
my-output = []
# functions to handle message event
buffer = []
var CharComp
var CompChar
var OrigChars
msg-before-data = ({data}) ->
  buffer.push data
msg-after-data = ({data}) ->
  my-input := data
  my-output := []
  comps = []
  get-comps = ->
    out = ""
    return out if it.length <= 0
    for char in it
      comps = CharComp[char]
      out += comps if comps
    it + get-comps out
  comps = get-comps my-input
  comps = Array::filter.call comps, -> it not in my-input
  console.log comps
  /*
  results = []
  do
    console.log comps.powerset!
    results = results.concat comps.powerset!
    Array::pop.call comps
  while comps.length isnt 0
  */
  for set in comps.powerset!
    console.log set
    for p in set.permutate!
      c = CompChar[p]
      my-output.push c if c and c in OrigChars
  # window.output my-output
  JSON.stringify my-output,, 2
# API
window.id = \lhc
window.reset = -> my-input := ""
window.input = -> msg-before-data {data: it}
window.addEventListener \message msg-before-data
window.output = ->
  return if window.muted
  window.top.postMessage it, origin
# load char to comps and comps to char table
d <- $.get \./data/char_comp_simple.json
CharComp := d
d <- $.get \./data/comp_char_simple.json
CompChar := d
d <- $.get \./data/orig-chars.json
OrigChars := d
window.input := -> msg-after-data {data: it}
window.removeEventListener \message, msg-before-data
for data in buffer
  msg-after-data {data}
window.addEventListener \message, msg-after-data


