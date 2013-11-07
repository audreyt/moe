window.camera = window.scene = window.renderer = window.controls = null
objects = []
targets = { table: [], sphere: [], helix: [], grid: [] }

window.init = function init(table)
  $('#container').remove!
  $(\<div/> id: \container).prependTo($ \body)
  $('#container').on \click \.symbol -> go-char { ch: $(@).text! }
  $('#container').on \click \.radical -> go-char { radical: $(@).text! }
  $('#container').on \click \.details -> go-char { bpmf: $(@).text! }
  l = table.length
  radius = Math.sqrt(l) * 56
  window.camera = camera = new THREE.PerspectiveCamera( 75, window.innerWidth / window.innerHeight, 1, (radius * 6.25) )
  camera.position.z = radius * 2
  camera.position.z = radius * 0.8 if l <= 25
  camera.position.z = radius * 0.4 if l <= 10
  camera.position.z = radius * 0.2 if l <= 5
  window.scene = scene = new THREE.Scene()
  for entry in table
    {ch, radical, strokes, bpmfs} = entry
    $(element).data entry
    element = document.createElement( 'div' )
    element.className = 'element'
    element.style.backgroundColor = 'rgb(220,201,172)' # + ( Math.random() * 0.25 + 0.75 ) + ')'
    element.style.border = '5px solid rgb(103,90,73)' # + ( Math.random() * 0.25 + 0.75 ) + ')'
    element.style.borderRadius = '10px' # + ( Math.random() * 0.25 + 0.75 ) + ')'
    element.style.backgroundImage = 'url("images/bg_element.png")'
    number = document.createElement( 'div' )
    if strokes
      number.className = 'number'
    else
      number.className = 'number radical'
    number.textContent = strokes || radical || ch
    element.appendChild( number )
    symbol = document.createElement( 'div' )
    symbol.className = 'symbol'
    symbol.textContent = ch
    element.appendChild( symbol )
    for bpmf, idx in bpmfs
      details = document.createElement( 'div' )
      details.className = "details idx-#{idx} total-#{bpmfs.length}"
      details.innerHTML = bpmf
      element.appendChild( details )
    object = new THREE.CSS3DObject( element )
    object.position.x = Math.random() * (radius * 5) - (radius * 2.5)
    object.position.y = Math.random() * (radius * 5) - (radius * 2.5)
    object.position.z = Math.random() * (radius * 5) - (radius * 2.5)
    scene.add( object )
    objects.push( object )

  vector = new THREE.Vector3()

  for obj, i in objects
    phi = Math.acos( -1 + ( 2 * i ) / l )
    theta = Math.sqrt( l * Math.PI ) * phi
    object = new THREE.Object3D()
    object.position.x = radius * Math.cos( theta ) * Math.sin( phi )
    object.position.y = radius * Math.sin( theta ) * Math.sin( phi )
    object.position.z = radius * Math.cos( phi )
    vector.copy( object.position ).multiplyScalar( 2 )
    object.lookAt( vector )
    targets.sphere.push( object )

  vector = new THREE.Vector3()

  distance = radius / 2
  distance = 300 if distance < 300
  for obj, i in objects
    phi = (objects.length - i) * 0.175 + Math.PI
    object = new THREE.Object3D()
    object.position.x = distance * 2.5 * Math.sin( phi )
    object.position.y = - ( (objects.length - i) * 8 ) + ( distance )
    object.position.z = distance * 2 * Math.cos( phi )
    vector.x = object.position.x * 2.5
    vector.y = object.position.y
    vector.z = object.position.z * 2
    object.lookAt( camera.position )
    targets.helix.push( object )

  distance = radius / 2
  distance = 150 if distance < 150
  for obj, i in objects
    object = new THREE.Object3D()
    object.position.x = ( ( i % 5 ) * distance ) - (distance * 2)
    object.position.y = ( 0 - ( Math.floor( i / 5 ) % 5 ) * distance * 1.2) + (distance * 2)
    object.position.z = ( Math.floor( i / 25 ) ) * (distance*2) - (4 * distance)
    targets.grid.push( object )

  window.renderer = renderer = new THREE.CSS3DRenderer()
  renderer.setSize( window.innerWidth, window.innerHeight )
  renderer.domElement.style.position = 'fixed'
  document.getElementById( 'container' ).appendChild( renderer.domElement )

  window.controls = controls = new THREE.TrackballControls( camera, renderer.domElement )
  controls.rotateSpeed = 0.5
  controls.addEventListener( 'change', render )

  button = document.getElementById( 'sphere' )
  button.addEventListener( 'click', (->
    $('#menu button').removeClass!
    $('#sphere').addClass "active"
    camera.position.z = radius * 2
    transform( targets.sphere, 2000 )
  ), false )
  button = document.getElementById( 'helix' )
  button.addEventListener( 'click', (->
    $('#menu button').removeClass!
    $('#helix').addClass "active"
    camera.position.z = radius * 2
    transform( targets.helix, 2000 )
  ), false )
  button = document.getElementById( 'grid' )
  button.addEventListener( 'click', (->
    $('#menu button').removeClass!
    $('#grid').addClass "active"
    camera.position.z = radius * 0.8 if l <= 25
    camera.position.z = radius * 0.4 if l <= 10
    camera.position.z = radius * 0.2 if l <= 5
    transform( targets.grid, 2000 )
  ), false )
  transform( targets.grid, 2500 )
  window.addEventListener( 'resize', onWindowResize, false )

window.transform = function transform( targets, duration )
  duration /= 2
  TWEEN.removeAll()
  for object, i in objects
    target = targets[ i ]
    new TWEEN.Tween( object.position )
      .to( { x: target.position.x, y: target.position.y, z: target.position.z }, Math.random() * duration + duration )
      .easing( TWEEN.Easing.Exponential.InOut )
      .start()
    new TWEEN.Tween( object.rotation )
      .to( { x: target.rotation.x, y: target.rotation.y, z: target.rotation.z }, Math.random() * duration + duration )
      .easing( TWEEN.Easing.Exponential.InOut )
      .start()
  new TWEEN.Tween( this )
    .to( {}, duration * 2 )
    .onUpdate( render )
    .start()

isResizing = false
w = h = null
cur-w = window.innerWidth
cur-h = window.innerHeight
window.onWindowResize = function onWindowResize()
  isResizing := true
  setTimeout checkResize, 100ms

function checkResize
  return unless isResizing
  if w is window.innerWidth and h is window.innerHeight
    if cur-w isnt w or cur-h isnt h
      cur-w := w; cur-h := h
      camera.aspect = w / h
      camera.updateProjectionMatrix!
      renderer.setSize w, h
      render!
    isResizing := false
  else
    w := window.innerWidth
    h := window.innerHeight
    setTimeout checkResize, 100ms

window.animate = function animate()
  requestAnimationFrame( animate )
  TWEEN.update!
  controls.update!

window.render = function render()
  renderer.render( scene, camera )
