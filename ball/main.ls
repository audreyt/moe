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
  function x => it - /[`~]/g
  for char in it
    continue unless Shape[char]
    for ch in char + Shape[char] => draw ch

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

function go-radical
  $out.empty!
  for ch in RadicalSame[ it ] => draw ch
  return

function go-rhyme
  $out.empty!
  for ch in SoundRhyme[ (it - /[ˋˊˇ‧]/g)[*-1] ] => draw ch

function go-alike
  $out.empty!
  for ch in SoundAlike[ (it - /[ˋˊˇ‧]/g) ] => draw ch

table <- GET "Table.json"
init = ->
  window.camera = camera = new THREE.PerspectiveCamera 75, window.innerWidth / window.innerHeight, 1, 5000
  camera.position.z = 1500
  window.scene = scene = new THREE.Scene
  i = 0
  while i < table.length
    element = document.createElement 'div'
    element.className = 'element'
    element.style.backgroundColor = 'rgba(0,127,127,' + Math.random! * 0.5 + 0.25 + ')'
    number = document.createElement 'div'
    number.className = 'number'
    number.textContent = table[i + 4]
    element.appendChild number
    symbol = document.createElement 'div'
    symbol.className = 'symbol'
    symbol.textContent = table[i]
    element.appendChild symbol
    details = document.createElement 'div'
    details.className = 'details'
    details.innerHTML = table[i + 1] + '<br>' + table[i + 2]
    element.appendChild details
    object = new THREE.CSS3DObject element
    object.position.x = Math.random! * 4000 - 2000
    object.position.y = Math.random! * 4000 - 2000
    object.position.z = Math.random! * 4000 - 2000
    scene.add object
    objects.push object
    object = new THREE.Object3D
    object.position.x = table[i + 3] * 140 - 1330
    object.position.y = -(table[i + 4] * 180) + 990
    targets.table.push object
    i += 5
  vector = new THREE.Vector3
  i = 0
  l = objects.length
  while i < l
    phi = Math.acos -1 + 2 * i / l
    theta = (Math.sqrt l * Math.PI) * phi
    object = new THREE.Object3D
    object.position.x = 800 * Math.cos theta * Math.sin phi
    object.position.y = 800 * Math.sin theta * Math.sin phi
    object.position.z = 800 * Math.cos phi
    (vector.copy object.position).multiplyScalar 2
    object.lookAt vector
    targets.sphere.push object
    i++
  vector = new THREE.Vector3
  i = 0
  l = objects.length
  while i < l
    phi = i * 0.175 + Math.PI
    object = new THREE.Object3D
    object.position.x = 900 * Math.sin phi
    object.position.y = -(i * 8) + 450
    object.position.z = 900 * Math.cos phi
    vector.x = object.position.x * 2
    vector.y = object.position.y
    vector.z = object.position.z * 2
    object.lookAt vector
    targets.helix.push object
    i++
  i = 0
  while i < objects.length
    object = new THREE.Object3D
    object.position.x = i % 5 * 400 - 800
    object.position.y = -((Math.floor i / 5) % 5) * 400 + 800
    object.position.z = (Math.floor i / 25) * 1000 - 2000
    targets.grid.push object
    i++
  window.renderer = renderer = new THREE.CSS3DRenderer
  renderer.setSize window.innerWidth * 0.7, window.innerHeight
  renderer.domElement.style.position = 'absolute'
  (document.getElementById 'container').appendChild renderer.domElement
  window.controls = controls = new THREE.TrackballControls camera, renderer.domElement
  controls.rotateSpeed = 0.5
  controls.addEventListener 'change', render
  button = document.getElementById 'table'
  button.addEventListener 'click', ((event) -> transform targets.table, 2000), false
  button = document.getElementById 'sphere'
  button.addEventListener 'click', ((event) -> transform targets.sphere, 2000), false
  button = document.getElementById 'helix'
  button.addEventListener 'click', ((event) -> transform targets.helix, 2000), false
  button = document.getElementById 'grid'
  button.addEventListener 'click', ((event) -> transform targets.grid, 2000), false
  transform targets.sphere, 5000
  window.addEventListener 'resize', onWindowResize, false
  /*
  $iframe = $ '<iframe src="https://www.moedict.tw/#~@" style="height: 100%; width: 30%; right: 0; position: fixed">'
  ($ 'body').append $iframe
  ($ 'body').on 'click', '.element', -> $iframe.attr 'src', 'https://www.moedict.tw/#~@' + encodeURIComponent ($ '.symbol', this).text!
  */

transform = (targets, duration) ->
  TWEEN.removeAll!
  i = 0
  while i < objects.length
    object = objects[i]
    target = targets[i]
    (((new TWEEN.Tween object.position).to target.position{x, y, z}, Math.random! * duration + duration).easing TWEEN.Easing.Exponential.InOut).start!
    (((new TWEEN.Tween object.rotation).to target.rotation{x, y, z}, Math.random! * duration + duration).easing TWEEN.Easing.Exponential.InOut).start!
    i++
  (((new TWEEN.Tween this).to {}, duration * 2).onUpdate render).start!

onWindowResize = ->
  camera.aspect = window.innerWidth / window.innerHeight
  camera.updateProjectionMatrix!
  renderer.setSize window.innerWidth, window.innerHeight
  render!

animate = ->
  requestAnimationFrame animate
  TWEEN.update!
  controls.update!

render = -> renderer.render scene, camera

objects = []

targets = {
  table: []
  sphere: []
  helix: []
  grid: []
}

init!

animate!
