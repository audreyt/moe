// Generated by LiveScript 1.2.0
(function(){
  var fs, Sound, Reverse, k, v, vs, i$, len$;
  fs = require('fs');
  Sound = JSON.parse(fs.readFileSync('Sound.json'));
  Reverse = {};
  for (k in Sound) {
    v = Sound[k];
    if (v.length === 1) {
      Reverse[v] == null && (Reverse[v] = k);
    }
  }
  for (k in Sound) {
    vs = Sound[k];
    if (vs.length > 1) {
      for (i$ = 0, len$ = vs.length; i$ < len$; ++i$) {
        v = vs[i$];
        Reverse[v] == null && (Reverse[v] = k);
      }
    }
  }
  console.log(JSON.stringify(Reverse, void 8, 2));
}).call(this);
