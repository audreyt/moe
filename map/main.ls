<- $

CACHED = {}; window.GET = GET = (url, data, onSuccess, dataType) ->
  if data instanceof Function
    [data, dataType, onSuccess] = [null, onSuccess, data]
  return onSuccess(CACHED[url]) if CACHED[url]
  $.get(url, data, (->
    onSuccess(CACHED[url] = it)
  ), (dataType || \json)).fail ->
    #x = decodeURIComponent(url) - /\.json$/ - /^\w/
    #window.input x

longMIN = 120
longMAX = 122
latMIN = 22
latMAX = 25

origin = "http://direct.moedict.tw/"
window.id = \map

$(\body).on \click 'a.poi' -> output("#{ $(@).text() }")
$(\#submitStr).click ->
  geo = STR2GEO($(\#inputStr).val!)
  $(\#inputX).val geo.x
  $(\#spanLong).text geo.longitude
  $(\#inputY).val geo.y
  $(\#spanLat).text geo.latitude

$(window).resize ->
  $('#map').width('100%')
  $('#map').height('100%')

$(\#submitGeo).click ->
  $(\#inputStr).val GEO2STR({ x: parseInt($(\#inputX).val!), y: parseInt($(\#inputY).val! )})

window.input = ->
  #window.geo = STR2GEO it
  fill it
window.output = ->
  input it
  return if window.muted
  window.parent.post? it, window.id

DATA = {}
#do
#  <- $.getJSON \orig-chars.json
#  DATA['j'] = it

window.STR2GEO = STR2GEO = ->
  long = DATA['j'].indexOf(it[0])
  lat = DATA['j'].indexOf(it[1])
  
  for i from 2 til it.length
    char = DATA['j'].indexOf(it[i])
    high = Math.floor(char / 64)
    low = char % 64
    long = (long * 64) + high
    lat = (lat * 64) + low
    
  rX = long
  rY = lat
  rLong = rX / (2 ** (it.length*6))
  rLat = rY / (2 ** (it.length*6))

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

fill ''
