<- $

$in = $ \#input
$out = $ \#output

origin = "http://127.0.0.1:8888/"
window.id = \tmuse
window.reset = -> $in.val ''
window.addEventListener("message", -> window.input it.data, false);
window.input = ->
  $in.val it
  json <- GET "a/#it.json"
#draw nodes
  nodes = json.graph_json.nodes
  $out.empty!
  #for {label} in nodes
  #  $out.append($(\<li/>).append $(\<a/> href: \#).text label .click -> window.output $(@).text!)

  scene = new THREE.Scene()
  window.camera = camera = new THREE.PerspectiveCamera(75, window.innerWidth/window.innerHeight, 0.1, 1000)
  renderer = new THREE.WebGLRenderer()
  renderer.setSize(window.innerWidth, window.innerHeight)
  $(\#canvas).html(renderer.domElement)

  camera.position.z = 5;
  multiplier = 5
  for {coords} in nodes
    sphere_geo = new THREE.SphereGeometry(0.1,10,10)
    mat = new THREE.MeshBasicMaterial({color: 0x0000ff})
    sphere = new THREE.Mesh(sphere_geo, mat)
    sphere.position.x = coords[0]*multiplier
    sphere.position.y = coords[1]*multiplier
    sphere.position.z = coords[2]*multiplier
    scene.add(sphere)
#draw edges
  edges = json.graph_json.edges
  for edge in edges
    mat = new THREE.LineBasicMaterial({color: 0x0000ff})
    sv = nodes[edge.s].coords
    tv = nodes[edge.t].coords
    geometry = new THREE.Geometry()
    geometry.vertices.push(new THREE.Vector3(sv[0]*multiplier, sv[1]*multiplier, sv[2]*multiplier))
    geometry.vertices.push(new THREE.Vector3(tv[0]*multiplier, tv[1]*multiplier, tv[2]*multiplier))

    line = new THREE.Line(geometry, mat)
    scene.add(line)
  controls = new THREE.OrbitControls(camera, renderer.domElement);

  render = ->
    requestAnimationFrame(render);
    renderer.render(scene, camera);

  render!;

window.output = ->
  return if window.muted
  input it
  window.top.postMessage(it, origin)

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
