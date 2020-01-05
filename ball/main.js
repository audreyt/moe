// Generated by LiveScript 1.6.0
(function(){
  var replace$ = ''.replace, split$ = ''.split;
  $(function(){
    var CACHED, GET, $in, $out;
    CACHED = {};
    GET = function(url, data, onSuccess, dataType){
      var ref$;
      if (data instanceof Function) {
        ref$ = [null, onSuccess, data], data = ref$[0], dataType = ref$[1], onSuccess = ref$[2];
      }
      if (CACHED[url]) {
        return onSuccess(CACHED[url]);
      }
      return $.get(url, data, function(it){
        return onSuccess(CACHED[url] = it);
      }, dataType || 'json').fail(function(){});
    };
    $in = $('#input');
    $out = $('#output');
    return GET("Shape.json", function(Shape){
      return GET("Sound.json", function(Sound){
        return GET("Radical.json", function(Radical){
          return GET("RadicalSame.json", function(RadicalSame){
            return GET("SoundRhyme.json", function(SoundRhyme){
              return GET("SoundAlike.json", function(SoundAlike){
                var origin, uniq;
                origin = "http://direct.moedict.tw/";
                window.id = 'ball';
                window.reset = function(){
                  return $in.val('');
                };
                window.addEventListener("message", function(it){
                  return window.input(it.data, false);
                });
                window.input = function(ch){
                  var ref$;
                  if (!(ch && Sound[ch[0]])) {
                    return;
                  }
                  $in.val(ch);
                  $out.empty();
                  if (ch.length > 1) {
                    ch = ch[0];
                  }
                  return window.showAll({
                    ch: ch,
                    bpmf: (ref$ = Sound[ch]) != null ? ref$[0] : void 8,
                    radical: Radical[ch]
                  });
                };
                window.output = function(it){
                  var ref$;
                  if (window.muted) {
                    return;
                  }
                  return typeof (ref$ = window.parent).post == 'function' ? ref$.post(it, window.id) : void 8;
                };
                function draw(ch){
                  var parts, i$, ref$, len$, s, $li, p;
                  parts = [];
                  parts.push($('<a/>', {
                    href: '#'
                  }).text(ch).click(function(){
                    return window.output($(this).text());
                  }));
                  for (i$ = 0, len$ = (ref$ = Sound[ch] || []).length; i$ < len$; ++i$) {
                    s = ref$[i$];
                    parts.push($('<a/>', {
                      href: '#'
                    }).text(s).click(fn$));
                  }
                  parts.push($('<a/>', {
                    href: '#'
                  }).text(Radical[ch]).click(function(){
                    return goRadical($(this).text());
                  }));
                  $li = $('<li/>');
                  for (i$ = 0, len$ = parts.length; i$ < len$; ++i$) {
                    p = parts[i$];
                    $li.append(p);
                    $li.append('&nbsp;');
                  }
                  return $li.appendTo($out);
                  function fn$(){
                    return goAlike($(this).text());
                  }
                }
                window.renderChars = (function(){
                  function renderChars(it){
                    var table, i$, len$, ch, radical, bpmfs;
                    window.table = table = [];
                    for (i$ = 0, len$ = it.length; i$ < len$; ++i$) {
                      ch = it[i$];
                      if (!Sound[ch]) {
                        continue;
                      }
                      radical = Radical[ch];
                      bpmfs = Sound[ch];
                      table.push({
                        ch: ch,
                        bpmfs: bpmfs,
                        radical: radical
                      });
                    }
                    window.init(table);
                    return window.animate();
                  }
                  return renderChars;
                }());
                window.showChars = (function(){
                  function showChars(chars){
                    if (!chars) {
                      return;
                    }
                    if (window.location === "?" + encodeURIComponent(chars)) {
                      return;
                    }
                    if (window.location === "?" + chars) {
                      return;
                    }
                    return window.location.href = window.location.pathname + ("?" + encodeURIComponent(chars));
                  }
                  return showChars;
                }());
                function goRadical(it){
                  return showChars(RadicalSame[it]);
                }
                function goRhyme(it){
                  var ref$;
                  return showChars(SoundRhyme[(ref$ = replace$.call(it, /[ˋˊˇ‧]/g, ''))[ref$.length - 1]]);
                }
                function goAlike(it){
                  return showChars(SoundAlike[replace$.call(it, /[ˋˊˇ‧]/g, '')]);
                }
                window.uniq = uniq = function(it){
                  var seen, out, i$, ref$, len$, w;
                  seen = {};
                  out = '';
                  for (i$ = 0, len$ = (ref$ = split$.call(it, '')).length; i$ < len$; ++i$) {
                    w = ref$[i$];
                    if (!seen[w]) {
                      out += w;
                    }
                    seen[w] = true;
                  }
                  return out;
                };
                window.goChar = (function(){
                  function goChar(arg$){
                    var ch, bpmf, radical;
                    ch = arg$.ch, bpmf = arg$.bpmf, radical = arg$.radical;
                    if (ch) {
                      output(ch);
                    }
                    return setTimeout(function(){
                      return window.showAll({
                        ch: ch,
                        bpmf: bpmf,
                        radical: radical
                      });
                    }, 1);
                  }
                  return goChar;
                }());
                window.showAll = (function(){
                  function showAll(arg$){
                    var ch, ref$, bpmf, radical, sims, snds, rads, all;
                    ch = (ref$ = arg$.ch) != null ? ref$ : '', bpmf = arg$.bpmf, radical = arg$.radical;
                    sims = snds = rads = '';
                    if (ch) {
                      sims = goSimilar(ch) || '';
                    }
                    if (bpmf) {
                      snds = SoundAlike[replace$.call(bpmf, /[ˋˊˇ‧]/g, '')] || '';
                    }
                    if (radical) {
                      rads = RadicalSame[radical] || '';
                    }
                    if (sims.length > 50) {
                      sims = sims.slice(0, 50);
                    }
                    if (snds.length > 50) {
                      snds = snds.slice(0, 50);
                    }
                    all = uniq(ch + sims + snds + rads);
                    if (all.length > 100) {
                      all = all.slice(0, 100);
                    }
                    return showChars(all);
                  }
                  return showAll;
                }());
                window.goSimilar = (function(){
                  function goSimilar(it){
                    var sims, i$, len$, char;
                    sims = "";
                    for (i$ = 0, len$ = it.length; i$ < len$; ++i$) {
                      char = it[i$];
                      if (!Shape[char]) {
                        continue;
                      }
                      sims += char + Shape[char];
                    }
                    return sims;
                  }
                  return goSimilar;
                }());
                if (/[^?]/.exec(location.search + "")) {
                  return setTimeout(function(){
                    return renderChars(decodeURIComponent(location.search) + "");
                  }, 1);
                } else {
                  return setTimeout(function(){
                    return renderChars("萌夢孟懵懵朦檬氓濛猛盟盟矇矇蒙蜢錳");
                  }, 1);
                }
              });
            });
          });
        });
      });
    });
  });
}).call(this);
