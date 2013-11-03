<- $

$in = $ \#input
$out = $ \#output

$ \#submit .click -> input $in.val! if $in.val!

origin = "http://127.0.0.1:8888/"
window.id = \tmuse
window.colors = [[0,0,0],[87,87,87],[173,35,35],[42,75,215],[29,105,20],[129,38,192],[160,160,160],[129,197,122],[157,175,255],[41,208,208],[255,146,51],[255,238,51],[233,222,187],[255,205,243]]
window.reset = -> $in.val ''
window.addEventListener("message", -> window.input it.data, false);
window.input = ->
  $in.val it
  json <- GET "a/#it.json"
#draw nodes
  nodes = json.graph_json.nodes
  $out.empty!
  for {labels} in json.clustering_json
    $li = $ \<li/>
    for [label, score] in labels
      $li.append(
        $(\<a/> href: \#).text(label).click(-> window.output $(@).text!).css(fontSize: (15 * score) + 'px')
      )
      $li.append('&nbsp;')
    $li.appendTo $out

  scene = new THREE.Scene()
  window.camera = camera = new THREE.PerspectiveCamera(75, window.innerWidth/window.innerHeight, 0.1, 1000)
  renderer = new THREE.WebGLRenderer()
  renderer.setSize(window.innerWidth, window.innerHeight)
  $(\#canvas).html(renderer.domElement)

  camera.position.z = 5;
  multiplier = 5
  objs = {}
#clustering & coloring
  obj_coloring = {}
  obj_radius = {}
  clustering = json.clustering_json
  window.labels = []
  window.sprite_id_to_label = {}
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
    sphere = new THREE.Mesh(sphere_geo, mat)
    sphere.position.x = coords[0]*multiplier
    sphere.position.y = coords[1]*multiplier
    sphere.position.z = coords[2]*multiplier
    #scene.add(sphere)
    #objs[n.label] = sphere

    spritey = makeTextSprite( " #{n.label} ", obj_coloring[n.label]);
    spritey.position = sphere.position.clone().multiplyScalar(1.01);
    # scene.add(sphere)
    window.labels.push spritey
    scene.add( spritey );
    window.sprite_id_to_label[spritey.id] = n.label

#draw edges
  edges = json.graph_json.edges
  for edge in edges
    mat = new THREE.LineBasicMaterial({color: 0x000000, linewidth:2})
    color = obj_coloring[nodes[edge.s].label]
    mat.color.setRGB(color.r,color.g,color.b)
    mat.transparent = true
    mat.opacity = 0.1
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

  renderer.setClearColor(0xdddddd, 1);
  light = new THREE.PointLight(0xffffff);
  light.position.set(-100,200,100);
  scene.add(light);
  render!;

  document.addEventListener( 'mousedown', window.onDocumentMouseDown, false );

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


window.makeTextSprite = ( message, {r, g, b}, parameters ) ->
  parameters = {} if parameters === undefined

  fontface = "Lantinghei TC";
  fontsize = 24;
  borderThickness = 1;
  borderColor = { r:0, g:0, b:0, a:1.0 };
  backgroundColor = { r: Math.round(200 + r * 55), g: Math.round(200 + g * 55), b: Math.round(200 + b * 55), a:1.0 };
  console.log JSON.stringify backgroundColor,,2

  spriteAlignment = THREE.SpriteAlignment.topLeft;

  canvas = document.createElement('canvas');
  context = canvas.getContext('2d');
  context.font = "Bold " + fontsize + "px " + fontface;

  # get size data (height depends only on font size)
  metrics = context.measureText( message );
  textWidth = metrics.width;

  # background color
  context.fillStyle = "rgba(" + backgroundColor.r + "," + backgroundColor.g + "," + backgroundColor.b + "," + backgroundColor.a + ")";
  # border color
  context.strokeStyle = "rgba(" + borderColor.r + "," + borderColor.g + "," + borderColor.b + "," + borderColor.a + ")";

  context.lineWidth = borderThickness;
  window.roundRect(context, borderThickness/2, borderThickness/2, textWidth + borderThickness, fontsize * 1.4 + borderThickness, 6);
  # 1.4 is extra height factor for text below baseline: g,j,p,q.

  # text color
  context.fillStyle = "rgba(0, 0, 0, 1.0)";

  context.fillText( message, borderThickness, fontsize + borderThickness);

  # canvas contents will be used for a texture
  texture = new THREE.Texture(canvas) 
  texture.needsUpdate = true;

  spriteMaterial = new THREE.SpriteMaterial( { map: texture, useScreenCoordinates: false, alignment: spriteAlignment } );
  sprite = new THREE.Sprite( spriteMaterial );
  sprite.scale.set(2, 1, 0.04)
  return sprite

window.roundRect = (ctx, x, y, w, h, r) ->
  ctx.beginPath();
  ctx.moveTo(x+r, y);
  ctx.lineTo(x+w - r, y);
  ctx.quadraticCurveTo(x+w, y, x+w, y+r);
  ctx.lineTo(x+w, y+h - r);
  ctx.quadraticCurveTo(x+w, y+h, x+w - r, y+h);
  ctx.lineTo(x+r, y+h);
  ctx.quadraticCurveTo(x, y+h, x, y+h - r);
  ctx.lineTo(x, y+r);
  ctx.quadraticCurveTo(x, y, x+r, y);
  ctx.closePath();
  ctx.fill();
  ctx.stroke();   

window.onDocumentMouseDown = ( event ) ->
  event.preventDefault();

  vector = new THREE.Vector3( ( event.clientX / window.innerWidth ) * 2 - 1, - ( event.clientY / window.innerHeight ) * 2 + 1, 0.5 );
  projector = new THREE.Projector()
  projector.unprojectVector( vector, camera );

  raycaster = new THREE.Raycaster( camera.position, vector.sub( camera.position ).normalize() );

  intersects = raycaster.intersectObjects( window.labels );

  console.log window.sprite_id_to_label[intersects[0].object.id]
  window.output window.sprite_id_to_label[intersects[0].object.id]

