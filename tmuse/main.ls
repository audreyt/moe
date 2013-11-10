<- $

$in = $ \#input
$out = $ \#output

$ \#submit .click -> input $in.val! if $in.val!

window.id = \tmuse
window.colors = [[42,75,215],[29,105,20],[129,38,192],[129,197,122],[157,175,255],[41,208,208],[255,146,51],[255,238,51],[233,222,187],[255,205,243]]
window.reset = -> $in.val ''
window.input = ->
  $in.val it
  json <- GET "a/#it.json"
#draw nodes
  nodes = json.graph_json.nodes
  $out.empty!
  if false => for {labels} in json.clustering_json
    $li = $ \<li/>
    for [label, score] in labels
      $li.append(
        $(\<a/> href: \#).text(label).click(-> window.output $(@).text!).css(fontSize: (15 * score) + 'px')
      )
      $li.append('&nbsp;')
    $li.appendTo $out

  scene = new THREE.Scene()

  window.camera = camera = new THREE.PerspectiveCamera(75, window.innerWidth/window.innerHeight, 0.1, 1000)
  window.renderer = renderer = new THREE.WebGLRenderer()
  renderer.setSize(window.innerWidth, window.innerHeight)
  $(\#canvas).html(renderer.domElement)

  camera.position.z = 4.2
  multiplier = 5
  objs = {}
#clustering & coloring
  obj_coloring = {}
  obj_radius = {}
  clustering = json.clustering_json
  window.labels = []
  window.topic = null
  window.sprite_id_to_label = {}
  window.sprite_id_to_sprite = {}
  for cluster,i in clustering
    labels = cluster.labels
    c = i % window.colors.length
    for l in labels
      obj_coloring[l[0]] = {r:window.colors[c][0]/255,g: window.colors[c][1]/255, b: window.colors[c][2]/255}
      obj_radius[l[0]] = l[1]
# draw nodes  
  for n,i in nodes
    coords = n.coords
    sphere_geo = new THREE.SphereGeometry(obj_radius[n.label]*0.1 + 0.05,10,10)
    mat = new THREE.MeshBasicMaterial({color: 0x0000ff})
    mat.color.setRGB(obj_coloring[n.label].r, obj_coloring[n.label].g, obj_coloring[n.label].b)
    mat.wireframe = true
    sphere = new THREE.Mesh(sphere_geo, mat)
    sphere.position.x = coords[0]*multiplier
    sphere.position.y = coords[1]*multiplier
    sphere.position.z = coords[2]*multiplier
    scene.add( sphere )

    spritey = makeTextSprite( " #{n.label} ", obj_coloring[n.label])
    spritey.position = sphere.position.clone().multiplyScalar(1);
    window.labels.push sphere
    scene.add( spritey )
    window.sprite_id_to_label[sphere.id] = n.label
    window.sprite_id_to_sprite[sphere.id] = spritey

#draw edges
  edges = json.graph_json.edges
  for edge in edges
    mat = new THREE.LineBasicMaterial({color: 0x000000, linewidth: 1})
    color = obj_coloring[nodes[edge.s].label]
    mat.color.setRGB(color.r,color.g,color.b)
    mat.transparent = true
    mat.opacity = 0.333
    sv = nodes[edge.s].coords
    tv = nodes[edge.t].coords
    geometry = new THREE.Geometry()
    geometry.vertices.push(new THREE.Vector3(sv[0]*multiplier, sv[1]*multiplier, sv[2]*multiplier))
    geometry.vertices.push(new THREE.Vector3(tv[0]*multiplier, tv[1]*multiplier, tv[2]*multiplier))

    line = new THREE.Line(geometry, mat)
    scene.add(line)
  controls = new THREE.TrackballControls(camera, renderer.domElement)
  controls.rotateSpeed = 0.5

  render = ->
    renderer.render(scene, camera)
    controls.update!
    window.pointerDetectRay = projector.pickingRay(window.mouse2D.clone!, camera);
    requestAnimationFrame(render)

  renderer.setClearColor(0x111118, 1)

  window.pointerDetectRay = new THREE.Raycaster!
  window.pointerDetectRay.ray.direction.set(0, -1, 0);
  window.projector = new THREE.Projector!
  window.mouse2D = new THREE.Vector3(0, 0, 0)

  geometry = new THREE.Geometry
  for i from 0 to 1000
    vertex = new THREE.Vector3
    distance = 0;
    while distance < 500*500
      vertex.x = 1000 * Math.sin(2 * Math.random()-1)
      vertex.y = 1000 * Math.sin(2 * Math.random()-1)
      vertex.z = 1000 * Math.sin(2 * Math.random()-1)
      distance = vertex.x * vertex.x + vertex.y * vertex.y + vertex.z * vertex.z
      geometry.vertices.push( vertex );
  material = new THREE.ParticleBasicMaterial { +sizeAttenuation, -depthWrite, size: 2 }
  material.color.setRGB(0.6, 0.6, 0.4)
  particles = new THREE.ParticleSystem( geometry, material )
  particles.renderDepth = 0
  scene.add particles
  render!

$(window).resize ->
  window.renderer?setSize(window.innerWidth, window.innerHeight)
  window.camera?aspect = window.innerWidth / window.innerHeight
  window.camera?updateProjectionMatrix!

window.output = ->
  return if window.muted
  input it
  # window.top.postMessage(it, origin)
  window.parent.post? it, window.id

CACHED = {}
GET = (url, data, onSuccess, dataType) ->
  if data instanceof Function
    [data, dataType, onSuccess] = [null, onSuccess, data]
  return onSuccess(CACHED[url]) if CACHED[url]
  $.get(url, data, (->
    onSuccess(CACHED[url] = it)
  ), (dataType || \json)).fail ->
    #x = decodeURIComponent(url) - /\.json$/ - /^\w/
    #window.input x


window.makeTextSprite = ( message, {r, g, b}, parameters ) ->
  parameters = {} if parameters === undefined

  fontface = 'Heiti TC'
  fontsize = 64
  borderThickness = 1
  borderColor = { r:0, g:0, b:0, a:1.0 }
  backgroundColor = { r: Math.round(155 + r * 100), g: Math.round(155 + g * 100), b: Math.round(155 + b * 100), a:0.8 }
  #console.log JSON.stringify backgroundColor,,2

  spriteAlignment = THREE.SpriteAlignment.topLeft

  canvas = document.createElement('canvas')
  context = canvas.getContext('2d')
  context.font = "Bold " + fontsize + "px " + fontface

  # get size data (height depends only on font size)
  metrics = context.measureText( message )
  textWidth = metrics.width

  # background color
  context.fillStyle = "rgba(" + backgroundColor.r + "," + backgroundColor.g + "," + backgroundColor.b + "," + backgroundColor.a + ")"
  # border color
  context.strokeStyle = "rgba(" + borderColor.r + "," + borderColor.g + "," + borderColor.b + "," + borderColor.a + ")"

  context.lineWidth = borderThickness
  window.roundRect(context, borderThickness/2, borderThickness/2, textWidth + borderThickness, fontsize * 1.4 + borderThickness, 6)
  # 1.4 is extra height factor for text below baseline: g,j,p,q.

  # text color
  context.fillStyle = "rgba(0, 0, 0, 1.0)"
  context.fillText( message, borderThickness, fontsize + borderThickness)

  # canvas contents will be used for a texture
  texture = new THREE.Texture(canvas)
  texture.needsUpdate = true

  spriteMaterial = new THREE.SpriteMaterial( { map: texture, useScreenCoordinates: false, alignment: spriteAlignment } )
  sprite = new THREE.Sprite( spriteMaterial )
  sprite.scale.set(1, 0.5, 1)
  return sprite

window.roundRect = (ctx, x, y, w, h, r) ->
  ctx.beginPath()
  ctx.moveTo(x+r, y)
  ctx.lineTo(x+w - r, y)
  ctx.quadraticCurveTo(x+w, y, x+w, y+r)
  ctx.lineTo(x+w, y+h - r)
  ctx.quadraticCurveTo(x+w, y+h, x+w - r, y+h)
  ctx.lineTo(x+r, y+h)
  ctx.quadraticCurveTo(x, y+h, x, y+h - r)
  ctx.lineTo(x, y+r)
  ctx.quadraticCurveTo(x, y, x+r, y)
  ctx.closePath()
  ctx.fill()
  ctx.stroke();

window.onDocumentMouseMove = ( event ) ->
  event.preventDefault!
  return unless window.mouse2D
  window.mouse2D.x = (event.clientX / window.innerWidth) * 2 - 1;
  window.mouse2D.y = -(event.clientY / window.innerHeight) * 2 + 1;
  intersects = window.pointerDetectRay.intersectObjects window.labels
  return if topic and intersects.length and intersects.0.object.id is topic.id

  if topic
    topic.material.wireframeLinewidth = 1
    spritey = window.sprite_id_to_sprite[topic.id]
    spritey.scale.x = 1
    spritey.scale.y = 0.5
    spritey.rotation = 0

  if intersects.length
    document.body.style.cursor = \pointer
    window.topic = intersects.0.object
    topic.material.wireframeLinewidth = 2
    spritey = window.sprite_id_to_sprite[topic.id]
    spritey.scale.x = 2
    spritey.scale.y = 1
    spritey.rotation = 0.1
    window.x = spritey
  else
    window.topic = null
    document.body.style.cursor = \move

window.onDocumentClick = ( event ) ->
  intersects = window.pointerDetectRay.intersectObjects window.labels
  if intersects.length
    window.output window.sprite_id_to_label[intersects.0.object.id]

document.addEventListener( 'click', window.onDocumentClick, false )
document.addEventListener( 'mousemove', window.onDocumentMouseMove, false )

window.input $in.val!
