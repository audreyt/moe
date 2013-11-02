window.camera = window.scene = window.renderer = window.controls = null
objects = []
targets = { table: [], sphere: [], helix: [], grid: [] }

window.init = function init(table)
  $('#container').remove!
  $(\<div/> id: \container).prependTo($ \body)
  l = table.length
  radius = Math.sqrt(l) * 56
  window.camera = camera = new THREE.PerspectiveCamera( 75, window.innerWidth / window.innerHeight, 1, (radius * 6.25) )
  camera.position.z = (radius * 2)
  window.scene = scene = new THREE.Scene()
  for {ch, radical, strokes, bpmf} in table
    element = document.createElement( 'div' )
    element.className = 'element'
    element.style.backgroundColor = 'rgba(0,127,127,' + ( Math.random() * 0.5 + 0.25 ) + ')'
    number = document.createElement( 'div' )
    number.className = 'number'
    number.textContent = strokes || radical
    element.appendChild( number )
    symbol = document.createElement( 'div' )
    symbol.className = 'symbol'
    symbol.textContent = ch
    element.appendChild( symbol )
    details = document.createElement( 'div' )
    details.className = 'details'
    details.innerHTML = bpmf # TODO: Array
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
    phi = i * 0.175 + Math.PI
    object = new THREE.Object3D()
    object.position.x = distance * 2 * Math.sin( phi )
    object.position.y = - ( i * 8 ) + ( distance )
    object.position.z = distance * 2 * Math.cos( phi )
    vector.x = object.position.x * 2
    vector.y = object.position.y
    vector.z = object.position.z * 2
    object.lookAt( vector )
    targets.helix.push( object )

  distance = radius / 2
  distance = 150 if distance < 150
  for obj, i in objects
    object = new THREE.Object3D()
    object.position.x = ( ( i % 5 ) * distance ) - (distance * 2)
    object.position.y = ( 0 - ( Math.floor( i / 5 ) % 5 ) * distance ) + (distance * 2)
    object.position.z = ( Math.floor( i / 25 ) ) * (distance*2) - (4 * distance)
    targets.grid.push( object )

  window.renderer = renderer = new THREE.CSS3DRenderer()
  renderer.setSize( window.innerWidth, window.innerHeight )
  renderer.domElement.style.position = 'absolute'
  document.getElementById( 'container' ).appendChild( renderer.domElement )

  window.controls = controls = new THREE.TrackballControls( camera, renderer.domElement )
  controls.rotateSpeed = 0.5
  controls.addEventListener( 'change', render )

  button = document.getElementById( 'sphere' )
  button.addEventListener( 'click', (-> transform( targets.sphere, 2000 )), false )
  button = document.getElementById( 'helix' )
  button.addEventListener( 'click', (-> transform( targets.helix, 2000 )), false )
  button = document.getElementById( 'grid' )
  button.addEventListener( 'click', (-> transform( targets.grid, 2000 )), false )
  transform( targets.sphere, 5000 )
  window.addEventListener( 'resize', onWindowResize, false )

/*
$iframe = $('<iframe src="https://www.moedict.tw/#~@" style="height: 100%; width: 30%; right: 0; position: fixed">')
$('body').append($iframe)
$('body').on('click', '.element', function() {
$iframe.attr('src', 'https://www.moedict.tw/#~@' + encodeURIComponent($('.symbol', this).text()))
})
*/

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

window.onWindowResize = function onWindowResize()
  camera.aspect = window.innerWidth / window.innerHeight
  camera.updateProjectionMatrix()
  renderer.setSize( window.innerWidth, window.innerHeight )
  render!

window.animate = function animate()
  requestAnimationFrame( animate )
  TWEEN.update!
  controls.update!

window.render = function render()
  renderer.render( scene, camera )
