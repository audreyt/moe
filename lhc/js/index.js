// Generated by LiveScript 1.2.0
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
(function(){
  var buffer, bufferedMsgsFirst, renderer, scene, camera, light, render, controls, materialFront, material, blockMaterial, extrusionSettings, split$ = ''.split, join$ = [].join;
  buffer = [];
  bufferedMsgsFirst = function(arg$){
    var data;
    data = arg$.data;
    return buffer.push(data);
  };
  window.input = function(it){
    return bufferedMsgsFirst({
      data: it
    });
  };
  window.addEventListener('message', bufferedMsgsFirst);
  Physijs.scripts.worker = '../js/physijs_worker.js';
  Physijs.scripts.ammo = '../js/ammo.js';
  renderer = new THREE.WebGLRenderer;
  renderer.setSize(window.innerWidth, window.innerHeight - 48);
  $('body').prepend(renderer.domElement);
  scene = new Physijs.Scene({
    fixedTimeStep: 1 / 120
  });
  scene.addEventListener('update', function(){
    scene.simulate(void 8, 2);
    return controls.update();
  });
  camera = new THREE.PerspectiveCamera(45, window.innerWidth / (window.innerHeight - 48), 1, 100000);
  camera.position.set(0, 2000, 4000);
  camera.lookAt(new THREE.Vector3(0, 0, 0));
  scene.add(camera);
  scene.add(new THREE.AmbientLight(0x333333));
  light = new THREE.DirectionalLight(0xffffff);
  light.position.set(0, 2000, 500);
  light.target.position.set(0, 0, 0);
  scene.add(light);
  render = function(){
    requestAnimationFrame(render);
    renderer.render(scene, camera);
  };
  requestAnimationFrame(render);
  scene.simulate();
  controls = new THREE.OrbitControls(camera);
  materialFront = new THREE.MeshLambertMaterial({
    map: THREE.ImageUtils.loadTexture('./images/wood.jpg'),
    color: 0x999999,
    ambient: 0xF0F0F0
  });
  material = new Physijs.createMaterial(materialFront, 8, 0.4);
  blockMaterial = Physijs.createMaterial(new THREE.MeshLambertMaterial({
    map: new THREE.ImageUtils.loadTexture('./images/plywood.jpg', {
      ambient: 0xFF9999
    })
  }), 0.9, 0.5);
  blockMaterial.map.wrapS = blockMaterial.map.wrapT = THREE.RepeatWrapping;
  blockMaterial.map.repeat.set(1, 0.5);
  extrusionSettings = {
    amount: 100,
    bevelEnabled: false,
    material: blockMaterial,
    extrudeMaterial: blockMaterial
  };
  $.get('./data/char_comp_simple.json', function(CharComp){
    return $.get('./data/comp_char_sorted.json', function(CompChar){
      return $.get('./data/orig-chars.json', function(OrigChars){
        return $.get('./data/Outlines.json', function(Outlines){
          return $.get('./data/Centroids.json', function(Centroids){
            var cTime, cCounter, origin, $input, $output, uniq, main, getShapeOf, doAddChar, i$, ref$, len$, data;
            cTime = 2.0;
            cCounter = 0;
            origin = "http://127.0.0.1:8888/";
            window.id = 'lhc';
            window.reset = function(){
              $input.val("");
              $output.empty();
            };
            window.output = function(it){
              if (window.muted) {
                return;
              }
              if (window.parent !== window) {
                return window.parent.postMessage(it, origin);
              }
            };
            $input = $('#input');
            $output = $('#output');
            window.uniq = uniq = function(it){
              var seen, i$, ref$, len$, w;
              seen = {};
              for (i$ = 0, len$ = (ref$ = split$.call(it, '')).length; i$ < len$; ++i$) {
                w = ref$[i$];
                seen[w] = true;
              }
              return join$.call(Object.keys(seen).sort(), '');
            };
            main = function(arg$){
              var data, comps, getComps, seen, i$, len$, ch, scanned, queue, callback, count, ref$, taken, rest, c, head, keys, char;
              data = arg$.data;
              data = uniq($input.val() + data);
              $input.val(data);
              cCounter = 0;
              comps = [];
              getComps = function(it){
                var out, i$, len$, char, comps;
                out = "";
                for (i$ = 0, len$ = it.length; i$ < len$; ++i$) {
                  char = it[i$];
                  comps = CharComp[char];
                  out += CharComp[char] ? getComps(CharComp[char]) : char;
                }
                return it + out;
              };
              comps = uniq(getComps(data));
              seen = {};
              for (i$ = 0, len$ = comps.length; i$ < len$; ++i$) {
                ch = comps[i$];
                if (in$(ch, OrigChars)) {
                  seen[ch] = true;
                }
              }
              scanned = {
                '': true
              };
              queue = [];
              callback = null;
              queue = [['', comps]];
              count = 0;
              while (queue.length) {
                if (count++ > 1000) {
                  break;
                }
                ref$ = queue.shift(), taken = ref$[0], rest = ref$[1];
                if (!scanned[taken]) {
                  scanned[taken] = true;
                  c = CompChar[taken];
                  if (c && in$(c, OrigChars)) {
                    seen[c] = true;
                  }
                }
                if (rest.length === 0) {
                  break;
                }
                head = rest[0];
                rest = rest.substr(1);
                queue.push([taken, rest]);
                queue.push([taken + head, rest]);
              }
              keys = Object.keys(seen);
              $output.empty();
              for (i$ = 0, len$ = keys.length; i$ < len$; ++i$) {
                char = keys[i$];
                $output.append($('<li/>').css('width', ~~(window.innerWidth / keys.length) - 5).append($('<a/>', {
                  href: '#'
                }).text(char))).click(fn$);
              }
              return JSON.stringify(keys, void 8, 2);
              function fn$(){
                return window.output($(this).text());
              }
            };
            getShapeOf = function(it){
              var ret, i$, len$, stroke, shape, path, tokens, shiftNum, isOutline, cmd;
              ret = [];
              for (i$ = 0, len$ = it.length; i$ < len$; ++i$) {
                stroke = it[i$];
                shape = new THREE.Shape;
                path = new THREE.Path;
                tokens = stroke.split(' ');
                shiftNum = fn$;
                isOutline = true;
                while (tokens.length) {
                  cmd = tokens.shift();
                  switch (cmd) {
                  case 'M':
                    if (isOutline) {
                      shape.moveTo(shiftNum(), shiftNum());
                    } else {
                      path.moveTo(shiftNum(), shiftNum());
                    }
                    break;
                  case 'L':
                    while (tokens.length > 1) {
                      if (isOutline) {
                        shape.lineTo(shiftNum(), shiftNum());
                      } else {
                        path.lineTo(shiftNum(), shiftNum());
                      }
                      if (tokens[0] === 'Z') {
                        if (!isOutline) {
                          shape.holes.push(path);
                          path = new THREE.Path;
                        }
                        isOutline = false;
                        break;
                      }
                    }
                  }
                }
                ret.push(shape);
              }
              return ret;
              function fn$(){
                return parseInt(tokens.shift(), 10);
              }
            };
            doAddChar = function(it){
              var i$, len$, char, lresult$, randX, randY, i, ref$, shape, geometry, offset, m, mesh, results$ = [];
              for (i$ = 0, len$ = it.length; i$ < len$; ++i$) {
                char = it[i$];
                lresult$ = [];
                console.log("creating geometry for " + char);
                randX = Math.random() * 500 - 250;
                randY = Math.random() * 500 - 250;
                for (i in ref$ = getShapeOf(Outlines[char])) {
                  shape = ref$[i];
                  geometry = new THREE.ExtrudeGeometry(shape, extrusionSettings);
                  offset = new THREE.Vector3(+Centroids[char][i][0], -Centroids[char][i][1], extrusionSettings.amount / 2);
                  m = new THREE.Matrix4;
                  m.makeTranslation(-offset.x, -offset.y, -offset.z);
                  geometry.applyMatrix(m);
                  mesh = new Physijs.ConvexMesh(geometry, blockMaterial, 9);
                  mesh.position = offset.clone();
                  mesh.position.add(new THREE.Vector3(randX - 1075, randY + 1075, 0));
                  mesh.castShadow = true;
                  mesh.receiveShadow = true;
                  mesh._physijs.linearVelocity.x = 0;
                  mesh._physijs.linearVelocity.y = 0;
                  mesh._physijs.linearVelocity.z = 200;
                  lresult$.push(scene.add(mesh));
                }
                results$.push(lresult$);
              }
              return results$;
            };
            scene.addEventListener('update', function(){
              if (cCounter++ % ~~(cTime * 120) === 0) {
                return doAddChar($input.val());
              }
            });
            window.input = function(it){
              return main({
                data: it
              });
            };
            window.removeEventListener('message', bufferedMsgsFirst);
            for (i$ = 0, len$ = (ref$ = buffer).length; i$ < len$; ++i$) {
              data = ref$[i$];
              main({
                data: data
              });
            }
            return window.addEventListener('message', main);
          });
        });
      });
    });
  });
  function in$(x, xs){
    var i = -1, l = xs.length >>> 0;
    while (++i < l) if (x === xs[i]) return true;
    return false;
  }
}).call(this);
