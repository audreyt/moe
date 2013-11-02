<- $

longMIN = 120
longMAX = 122
latMIN = 22
latMAX = 25

origin = "http://127.0.0.1:8888/"
window.id = \map
window.addEventListener("message", -> window.input it.data , false)

$(\#submitStr).click ->
  $(\#inputLong).val STR2GEO($(\#inputStr).val!).longitude
  $(\#inputLat).val STR2GEO($(\#inputStr).val!).latitude

$(\#submitGeo).click ->
  $(\#inputStr).val GEO2STR({ longitude: parseFloat($(\#inputLong).val!),latitude: parseFloat($(\#inputLat).val!)})

window.input = ->
  window.geo = STR2GEO it
window.output = ->
  return if window.muted
  input it
  window.top.postMessage(it, origin)

DATA = {}
do
  <- $.getJSON \orig-chars.json
  DATA['j'] = it

window.STR2GEO = STR2GEO = ->
  long = DATA['j'].indexOf(it[0])
  lat = DATA['j'].indexOf(it[1])
  
  for i from 2 til it.length
    char = DATA['j'].indexOf(it[i])
    high = Math.floor(char / 64)
    low = char % 64
    long = (long * 64) + high
    lat = (lat * 64) + low
    
  rX = (parseInt long.toString(2), 2)
  rY = (parseInt lat.toString(2), 2)
  rLong = rX / (2 ** (long.toString(2).length))
  rLat = rY / (2 ** (long.toString(2).length))

  { longitude: longMIN + (longMAX - longMIN) * rLong, latitude: latMIN + (latMAX - latMIN)*rLat, x: rX, y: rY }
  
window.GEO2STR = GEO2STR = ->
  long = it.x
  lat = it.y

  long_parts = []
  lat_parts = []
  
  if long >= lat
    while long > 0
      long_parts.unshift (long % 64).toString(2)
      long = Math.floor(long / 64)
      lat_parts.unshift (lat % 64).toString(2)
      lat = Math.floor(lat / 64)
  else
    while lat > 0
      long_parts.unshift (long % 64).toString(2)
      long = Math.floor(long / 64)
      lat_parts.unshift (lat % 64).toString(2)
      lat = Math.floor(lat / 64)

  if long_parts.length < 3
    for til 3 - long_parts.length
      long_parts.unshift "0"
  if lat_parts.length < 3
    for til 3 - lat_parts.length
      lat_parts.unshift "0"
  result = ""
  c1 = DATA['j'][(parseInt(long_parts[0],2) * 64) + parseInt(long_parts[1],2)]
  long_parts.shift!
  long_parts.shift!
  result += c1
  c2 = DATA['j'][(parseInt(lat_parts[0],2) * 64) + parseInt(lat_parts[1],2)]
  lat_parts.shift!
  lat_parts.shift!
  result += c2

  for i from 0 til long_parts.length
    result += DATA['j'][(parseInt(long_parts[i],2) * 64) + parseInt(lat_parts[i],2)]

  result

