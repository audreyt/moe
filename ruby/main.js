// Generated by LiveScript 1.2.0
(function(){
  var ref$, button, label, ul, li, span, div, input, textarea;
  ref$ = React.DOM, button = ref$.button, label = ref$.label, ul = ref$.ul, li = ref$.li, span = ref$.span, div = ref$.div, input = ref$.input, textarea = ref$.textarea;
  $.getJSON('Sound.json', function(Sound){
    return $.getJSON('Reverse.json', function(Reverse){
      var Body;
      Body = React.createClass({
        getInitialState: function(){
          return {
            value: '認得幾個字？',
            alt: {}
          };
        },
        render: function(){
          var value;
          value = this.state.value;
          return div({}, input({
            onChange: bind$(this, 'onChange'),
            value: value,
            id: 'main',
            autoFocus: true
          }), button({
            id: 'speak',
            onClick: bind$(this, 'onClick')
          }, '▶'), textarea({
            value: this.getRuby(value)
          }), ul.apply(null, [{}].concat((function(){
            var i$, len$, results$ = [];
            for (i$ = 0, len$ = value.length; i$ < len$; ++i$) {
              results$.push((fn$.call(this, i$, value[i$])));
            }
            return results$;
            function fn$(idx, ch){
              if (Sound[ch]) {
                return li.apply(null, [{}, span({}, ch)].concat((function(){
                  var i$, len$, results$ = [];
                  for (i$ = 0, len$ = Sound[ch].length; i$ < len$; ++i$) {
                    results$.push((fn$.call(this, i$, Sound[ch][i$])));
                  }
                  return results$;
                  function fn$(i, yin){
                    var this$ = this;
                    return label({}, input({
                      key: "alt-" + idx + ch + i,
                      type: 'radio',
                      name: "alt-" + idx + ch + i,
                      value: i,
                      checked: +i === +(this.state["alt-" + idx + ch] || 0),
                      onChange: function(it){
                        var ref$;
                        return this$.setState((ref$ = {}, ref$["alt-" + idx + ch] = it.target.value, ref$));
                      }
                    }), span({}, yin));
                  }
                }.call(this))));
              } else {
                return span({
                  style: {
                    fontSize: '19px'
                  }
                }, ch);
              }
            }
          }.call(this)))));
        },
        onChange: function(arg$){
          var value;
          value = arg$.target.value;
          return this.setState({
            value: value
          });
        },
        onClick: function(it){
          var text, idx, syn, utt, u, e;
          text = (function(){
            var i$, ref$, len$, results$ = [];
            for (i$ = 0, len$ = (ref$ = this.getSounds()).length; i$ < len$; ++i$) {
              idx = i$;
              it = ref$[i$];
              results$.push(Reverse[it] || this.state.value[idx]);
            }
            return results$;
          }.call(this)).join('');
          try {
            syn = window.speechSynthesis;
            utt = window.SpeechSynthesisUtterance;
            u = new utt(text);
            u.lang = 'zh-TW';
            return syn.speak(u);
          } catch (e$) {
            e = e$;
            return alert(text);
          }
        },
        getSounds: function(){
          var i$, ref$, len$, idx, ch, results$ = [];
          for (i$ = 0, len$ = (ref$ = this.state.value).length; i$ < len$; ++i$) {
            idx = i$;
            ch = ref$[i$];
            results$.push((Sound[ch] || [])[this.state["alt-" + idx + ch] || 0] || '');
          }
          return results$;
        },
        getRuby: function(it){
          var sounds, idx, ch, that;
          sounds = this.getSounds();
          return ("" + (function(){
            var i$, ref$, len$, results$ = [];
            for (i$ = 0, len$ = (ref$ = it).length; i$ < len$; ++i$) {
              idx = i$;
              ch = ref$[i$];
              results$.push(((that = sounds[idx])
                ? "\n<ruby>" + ch + "<rt>" + that + "</rt></ruby>\n"
                : ch + "") + "");
            }
            return results$;
          }()).join("")).replace(/\n+/g, "\n").replace(/^\n+/, '').replace(/\n+$/, '');
        }
      });
      return $(function(){
        return React.renderComponent(Body(), document.body);
      });
    });
  });
  function bind$(obj, key, target){
    return function(){ return (target || obj)[key].apply(obj, arguments) };
  }
}).call(this);