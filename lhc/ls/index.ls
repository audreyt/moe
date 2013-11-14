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
buffered-msgs-first = ({data}) -> buffer.push data unless data in buffer
window.input = -> buffered-msgs-first {data: it}
#window.addEventListener \message buffered-msgs-first


# initialize three.js and Physijs
Physijs.scripts.worker = \../js/physijs_worker.js
Physijs.scripts.ammo = \../js/ammo.js

renderer = new THREE.WebGLRenderer
renderer.setSize(window.innerWidth, (window.innerHeight - 48))
#renderer.shadowMapEnabled = yes
#renderer.shadowMapSoft = yes
$(\body).prepend renderer.domElement

scene= new Physijs.Scene(fixedTimeStep: 1 / 24)
scene.fog = new THREE.FogExp2( 0x222222, 0.00005 );
geometry = new THREE.Geometry
for i from 0 to 500
  vertex = new THREE.Vector3
  distance = 0;
  while distance < 500*500
    vertex.x = 5000 * Math.sin(2 * Math.random()-1)
    vertex.y = 5000 * Math.sin(2 * Math.random()-1)
    vertex.z = 5000 * Math.sin(2 * Math.random()-1)
    distance = vertex.x * vertex.x + vertex.y * vertex.y + vertex.z * vertex.z
    geometry.vertices.push( vertex );
material = new THREE.ParticleBasicMaterial { +sizeAttenuation, -depthWrite, size: 2 }
material.color.setRGB(0.7, 0.7, 0.8)
particles = new THREE.ParticleSystem( geometry, material )
particles.renderDepth = 0
scene.add particles
scene.addEventListener \update, ->
  scene.simulate(void, 2)
  controls.update!

camera = new THREE.PerspectiveCamera(45, window.innerWidth / (window.innerHeight - 48), 1, 50000)
camera.position.set(0, 2000, 4000)
camera.lookAt new THREE.Vector3(0, 0, 0)
scene.add camera

scene.add new THREE.AmbientLight(0x333333)
light = new THREE.DirectionalLight(0x999999)
light.position.set(0, 2000, 500)
light.target.position.set(0, 0, 0)
scene.add light
light = new THREE.SpotLight(0x999999)
light.position.set(0, 2000, 500)
light.target.position.set(0, 0, 0)
scene.add light
light = new THREE.SpotLight(0x999999)
light.position.set(0, -2000, -500)
light.target.position.set(0, 0, 0)
scene.add light

window.addEventListener \resize, ->
  renderer.setSize(window.innerWidth, (window.innerHeight - 48))
  camera.aspect = window.innerWidth / (window.innerHeight - 48)
  camera.updateProjectionMatrix!

render = !->
  requestAnimationFrame(render)
  renderer.render(scene, camera)
requestAnimationFrame(render)
scene.simulate!

controls = new THREE.TrackballControls camera
controls.rotateSpeed = 0.5

window.colors = [[42,75,215],[29,105,20],[129,38,192],[129,197,122],[157,175,255],[41,208,208],[255,146,51],[255,238,51],[233,222,187],[255,205,243]]
window.materials = for [r,g,b] in window.colors
  r = Math.round r / 4 + 128
  g = Math.round g / 4 + 128
  b = Math.round b / 4 + 64
  Physijs.createMaterial do
    new THREE.MeshPhongMaterial color: (r*65536 + g*256 + b), specular: (r*65536 + g*256 + b), shininess: 10, shading: THREE.FlatShading
    #map: new THREE.ImageUtils.loadTexture \./images/plywood.jpg
    0.9 # medium friction
    0.5 # medium restitution

extrusionSettings =
  amount: 100
  bevelEnabled: true
  #material: block-material
  #extrudeMaterial: block-material

CACHED = { "./a/萌.json": { "ch": "萌", "outlines": [
    "M 1233 -469 L 1211 -549 1192 -614 1180 -656 1173 -680 1184 -685.5 1195 -691 1207 -676 1236 -639 1255 -614 1271.5 -581 1288 -548 1302 -517.5 1316 -487 1333 -450 1403 -444 1476 -436 1570 -433 1617 -430 1641 -429 1657.5 -423 1674 -417 1676 -408 1677 -400 1659.5 -385.5 1642 -371 1605 -355 1568 -339 1551 -338 1535 -338 1498 -348 1461 -358 1432.5 -363 1404 -368 1367 -372 1383 -320 1400 -280 1409 -256 1413.5 -248.5 1418 -241 1430 -227.5 1442 -214 1444 -207 1446 -195 1432 -179.5 1418 -164 1389 -151 1360 -138 1337 -127 1314 -116 1297 -116 1273 -117 1269 -125 1265 -133 1272 -154 1279 -175 1280 -198 1280 -221 1277 -243.5 1274 -266 1267 -302.5 1260 -339 1250 -397 1175 -410 1110 -421 1095 -422 1067 -424 1043 -426 1039.5 -434.5 1036 -443 1062.5 -459 1089 -475 1106.5 -482 1124 -489 1141 -489 1152 -490 1175 -483.5 1198 -477 Z",
    "M 796 -422 L 791 -374 786 -336 786 -321 784 -295 789 -272 794 -249 793 -243 788 -231 764 -221 704 -204 657 -191 640 -194 619 -198 614 -208.5 609 -219 628.5 -248 648 -277 652 -283.5 656 -290 670 -325.5 684 -361 688.5 -378 693 -395 699 -439 636 -447 561 -455 485 -464 449 -468 420.5 -462.5 392 -457 391 -457 370 -458 364 -467.5 358 -477 370 -493.5 382 -510 413.5 -536.5 445 -563 459 -572.5 473 -582 491 -580 502 -580 528.5 -565 555 -550 575 -543.5 595 -537 629.5 -528.5 664 -520 716 -505 755 -665 766 -711 784 -707.5 802 -704 811.5 -679.5 821 -655 819 -633 802 -483 947 -447 976 -440 974.5 -419.5 973 -399 938 -403 Z",
    "M 752 -1479 L 785 -1537 797 -1558 805 -1560 814 -1563 830 -1553.5 846 -1544 860.5 -1511 875 -1478 879 -1448 880 -1431 877 -1384.5 874 -1338 875 -1248 877 -1032 877 -998 877 -977 882 -953 887 -929 894 -914 908 -887 913 -877 912.5 -868 912 -859 898.5 -848 885 -837 856 -819.5 827 -802 809.5 -794.5 792 -787 771 -787 757 -788 727 -795 657 -812 613 -823 602 -825 476 -851 432 -840 395 -832 382 -834 358 -839 356 -849 354 -859 368 -876 382 -893 392 -908 394.5 -918.5 397 -929 399 -956 402 -988 402 -997 401 -1048 396 -1212 394 -1253 390 -1288.5 386 -1324 379 -1363 370 -1409 371.5 -1428 373 -1447 380 -1470.5 387 -1494 405 -1522 421 -1549 434.5 -1548.5 448 -1548 457 -1533 472 -1507 570 -1500 575 -1500 631 -1493.5 687 -1487 Z M 480 -1212 L 503 -1216 516 -1219 547.5 -1215.5 579 -1212 636.5 -1206.5 694 -1201 771 -1191 771 -1257 768 -1326 767 -1387 765 -1399 763 -1411 756 -1440 727 -1426 713 -1419 680 -1419 662 -1420 620 -1426.5 578 -1433 547.5 -1436.5 517 -1440 471 -1443 Z M 771 -1137 L 736 -1129 707 -1123 688 -1123 672 -1124 632 -1136 592 -1148 560 -1153.5 528 -1159 480 -1164 487 -898 646 -870 670 -866 698.5 -865.5 727 -865 740 -873 753 -881 759 -893 765 -905 766 -923 766 -948 Z",
    "M 1534 -1346 L 1532 -1549 1531 -1578 1524 -1635.5 1517 -1693 1510.5 -1712.5 1504 -1732 1494 -1737 1483 -1744 1466.5 -1740.5 1450 -1737 1426.5 -1726 1403 -1715 1366 -1699 1330 -1684 1311 -1677 1304 -1685.5 1297 -1694 1313 -1711 1335 -1736 1378 -1782 1384 -1789 1415 -1829 1446 -1869 1460 -1889.5 1474 -1910 1486.5 -1922 1499 -1934 1516 -1935 1533 -1937 1560.5 -1918 1588 -1899 1608.5 -1863.5 1629 -1828 1639 -1778 1649 -1728 1650 -1641 1650 -1581 1649 -1508 1647 -1405 1642 -1034 1641 -1006 1644 -966.5 1647 -927 1650.5 -901.5 1654 -876 1659.5 -847.5 1665 -819 1678 -797 1691 -775 1692 -769 1693 -753 1671 -731 1649 -709 1632.5 -699 1616 -689 1577.5 -670 1539 -651 1518 -654 1507 -656 1472.5 -674.5 1438 -693 1380 -706 1299 -724 1233 -740 1221 -742.5 1209 -745 1164 -750 1133 -739 1085 -722 1066 -717 1052 -717 1037 -718 1028.5 -725 1020 -732 1021 -743.5 1022 -755 1032 -775 1042 -795 1046.5 -820.5 1051 -846 1053 -890 1055 -934 1056 -964 1056 -977 1053.5 -1089.5 1051 -1202 1047.5 -1259.5 1044 -1317 1020.5 -1426.5 997 -1536 961 -1610 925 -1684 879 -1738.5 833 -1793 787 -1832 739 -1873 724 -1886 732.5 -1896.5 741 -1907 761 -1896 809 -1870 837 -1855 869.5 -1832.5 902 -1810 942 -1773.5 982 -1737 1018.5 -1682.5 1055 -1628 1076 -1569.5 1097 -1511 1105.5 -1477.5 1114 -1444 1124 -1405 1150 -1409 1185 -1415 1199 -1414 1217 -1414 1264.5 -1401 1312 -1388 1375 -1376.5 1438 -1365 Z M 1144 -1126 L 1175 -1132 1183 -1135 1223 -1127.5 1263 -1120 1316 -1109 1369 -1098 1414 -1087 1459 -1076 1529 -1058 1534 -1302 1500 -1290 1474 -1281 1442 -1282 1425 -1283 1391 -1292.5 1357 -1302 1290.5 -1317 1224 -1332 1201.5 -1336 1179 -1340 1127 -1348 1135 -1277 1138 -1248 1140 -1213.5 1142 -1179 Z M 1531 -1012 L 1489 -1001 1454 -992 1434 -993 1419 -994 1392 -1003.5 1365 -1013 1278 -1036 1200 -1059 1182 -1065 1147 -1073 1155 -977 1162 -895 1162 -858 1164 -848.5 1166 -839 1172 -823 1233 -808 1245 -805 1298.5 -797 1352 -789 1399.5 -781 1447 -773 1476 -772 1493 -772 1499.5 -776.5 1506 -781 1512 -791 1518 -801 1522.5 -818 1527 -835 1528 -873 Z" ], "centroids": [ [ "1338.92718489426", "378.097426152744" ], [ "686.479837421163", "444.310979677645" ], [ "647.703866880858", "1170.66246053884" ], [ "1355.89288956154", "1257.3425895333" ] ] }
}; MISSED = {}; GET = (url, data, onSuccess, dataType) ->
  if data instanceof Function
    [data, dataType, onSuccess] = [null, onSuccess, data]
  return onSuccess(CACHED[url]) if CACHED[url]
  return if MISSED[url]
  $.get(url, data, (->
    onSuccess(CACHED[url] = it)
  ), (dataType || \json)).fail -> MISSED[url] = true

# load data for chinese character composition/decomposition
CharComp  <- GET \./data/char_comp_simple.json
CompChar  <- GET \./data/comp_char_sorted.json
OrigChars <- GET \./data/orig-chars.json

#moe       <- $.get \./data/moe.json
###
# main function for Large Hanzi Collider
###
# API
cTime = 2.0
cCounter = 0
origin = "http://direct.moedict.tw/"
window.id = \lhc
window.reset = !->
  $input.val ""
  $output.empty!
window.output = ->
  return if window.muted
  window.parent.post? it, window.id
$input = $ \#input
$output = $ \#output
window.uniq = uniq = ->
  seen = {}
  result = ''
  for w in it / ''
    result += w unless seen[w]
    seen[w] = true
  return result
main = ({data}) ->
  data = uniq($input.val! + (data - /[-+;?.a-zA-Z0-9，。；？\s]/g))
  data.=substr(-10) if data.length > 10
  $input.val data
  cCounter := 0
  comps = []
  get-comps = ->
    out = ""
    for char in it
      comps = CharComp[char]
      out += if CharComp[char] then get-comps CharComp[char] else char
    it + out
  seen = {}
  for ch in data => seen[ch] = true if ch in OrigChars
  comps = uniq(get-comps data)
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
      seen[c.0] = true if c and c.0 in OrigChars
    continue if rest.length == 0
    head = rest.0
    rest.=substr(1)
    queue.push [taken, rest]
    queue.push [taken + head, rest]
  keys = data
  for k of seen | not ~data.indexOf(k)
    keys += k
  keys.=substr(-15) if keys.length > 15
  $output.empty!
  for char in keys => let char
    $output.append $(\<li/>).css(width: "#{ 90 / keys.length }%").append $(\<a/> href: \#).text(char).click ->
      window.doAddChar char
      window.output char
  return
getShapeOf = ->
  ret = []
  for stroke in (it || [])
    shape = new THREE.Shape
    path = new THREE.Path
    tokens = stroke.split ' '
    shiftNum = -> parseInt tokens.shift!, 10
    isOutline = yes
    while tokens.length
      cmd = tokens.shift!
      switch cmd
        when \M
          if isOutline
            shape.moveTo shiftNum!, shiftNum!
          else
            path.moveTo shiftNum!, shiftNum!
        when \L
          while tokens.length > 1
            if isOutline
              shape.lineTo shiftNum!, shiftNum!
            else
              path.lineTo shiftNum!, shiftNum!
            if tokens.0 is \Z
              if not isOutline
                shape.holes.push path
                path = new THREE.Path
              isOutline = no
              break
    ret.push shape
  ret
window.idx = 0
window.doAddChar = ->
  queue = []
  for char in it
    {ch: char, outlines, centroids} <- GET "./a/#char.json" 
    window.idx++
    # console.log "creating geometry for #char"
    randX = Math.random() * 500 - 250
    randY = Math.random() * 500 - 250
    for i, shape of getShapeOf outlines
      geometry = new THREE.ExtrudeGeometry(shape, extrusionSettings)
      offset = new THREE.Vector3 do
        +centroids[i].0
        -centroids[i].1
        extrusionSettings.amount / 2
      m = new THREE.Matrix4
      m.makeTranslation(-offset.x, -offset.y, -offset.z)
      geometry.applyMatrix m
      mesh = new Physijs.ConvexMesh(geometry, materials[window.idx % materials.length], 9)
      mesh.position = offset.clone!
      mesh.position.add new THREE.Vector3(randX - 1075, randY + 1075, 0)
      mesh.castShadow = yes
      mesh.receiveShadow = yes
      mesh._physijs.linearVelocity.x = Math.random() * 1000 - 500
      mesh._physijs.linearVelocity.y = Math.random() * 1000 - 500
      mesh._physijs.linearVelocity.z = Math.random() * 1000 - 500
      queue.push mesh
  do addObject = ->
    return setTimeout(addObject, 100ms) unless queue.length
    mesh = queue.shift!
    mesh.addEventListener \ready ->
      window.requestAnimationFrame addObject
      #mesh.setLinearVelocity new THREE.Vector3(0,0,-2000)
      mesh.setAngularVelocity new THREE.Vector3(Math.random() - 0.5, Math.random() - 0.5, Math.random() - 0.5)
    #mesh.addEventListener \collision -> for axis in <[ x y z ]>
    #  it.setLinearVelocity it.getLinearVelocity.multiplyScalar(2)
    #  it.setAngularVelocity it.getAngularVelocity.multiplyScalar(2)
    scene.add mesh
scene.addEventListener \update, ->
  window.doAddChar $input.val! if (cCounter++ % ~~(cTime * 120)) is 0
window.input := -> main {data: it}
#window.removeEventListener \message, buffered-msgs-first
#for data in buffer => main {data}
#window.addEventListener \message, main

if "#{ location.search }" is /[^?]/
  window.input decodeURIComponent location.search
else
  window.input \萌
