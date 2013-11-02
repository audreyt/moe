#window ?= -> { $: require(\jquery), addEventListener: -> }
/*
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
*/
# buffered messages before data loaded
buffer = []
buffered-msgs-first = ({data}) -> buffer.push data
window.input = -> buffered-msgs-first {data: it}
window.addEventListener \message buffered-msgs-first
# load data for chinese character composition/decomposition
CharComp <- $.get \./data/char_comp_simple.json
CompChar <- $.get \./data/comp_char_sorted.json
OrigChars <- $.get \./data/orig-chars.json
###
# main function for Large Henzi Collider
###
# API
origin = "http://127.0.0.1:8888/"
window.id = \lhc
window.reset = -> $input.val ""
window.output = ->
  return if window.muted
  window.top.postMessage it, origin
$input = $ \#input
$output = $ \#output
window.uniq = uniq = ->
  seen = {}
  for w in it / '' => seen[w] = true
  Object.keys(seen).sort! * ''
main = ({data}) ->
  data = uniq($input.val! + data)
  $input.val data
  comps = []
  get-comps = ->
    out = ""
    for char in it
      comps = CharComp[char]
      out += if CharComp[char] then get-comps CharComp[char] else char
    it + out
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
window.input := -> main {data: it}
window.removeEventListener \message, buffered-msgs-first
for data in buffer => main {data}
window.addEventListener \message, main

