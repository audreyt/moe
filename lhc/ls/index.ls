Array::powerset = ->
  return @ if @length <= 1
  xs = @slice!
  x = xs.pop!
  p = xs.powerset!
  p.concat p.map -> it.concat [x]
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
  for char in my-input
    continue if not CharComp[char]
    for {c} in CharComp[char] => comps.push c
  for maybe in comps.powerset!
    c = CompChar[maybe]
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
d <- $.get \./data/char_comp.json
CharComp := d
d <- $.get \./data/comp_char.json
CompChar := d
d <- $.get \./data/orig-chars.json
OrigChars := d
window.input := -> msg-after-data {data: it}
window.removeEventListener \message, msg-before-data
for data in buffer
  msg-after-data {data}
window.addEventListener \message, msg-after-data

