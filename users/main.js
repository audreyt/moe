// Generated by LiveScript 1.2.0
(function(){
  $(function(){
    var origin, url, connection;
    origin = "http://direct.moedict.tw/";
    url = 'https://goinstant.net/poga/yhd2013-moe-users';
    window.id = 'users';
    window.addEventListener("message", function(it){
      return window.input(it.data, false);
    });
    $(document).on('click', 'span', function(it){
      console.log($(it.target).text());
      return window.output($(it.target).text());
    });
    connection = new goinstant.Connection(url);
    return connection.connect(function(){
      var room;
      room = connection.room("game");
      return room.join(function(){
        var userList;
        userList = new goinstant.widgets.UserList({
          room: room,
          collapsed: false,
          position: 'left',
          userOptions: false
        });
        userList.initialize(function(it){
          if (it) {
            return console.log(it);
          }
        });
        window.reset = function(){
          return room.self().key('displayName').set("");
        };
        window.input = function(it){
          var text;
          text = it;
          return room.self().key('displayName').get(function(err, v, ctx){
            if (err) {
              connect.log(err);
            }
            console.log("v=" + v);
            return room.self().key('displayName').set(text);
          });
        };
        window.output = function(it){
          var ref$;
          if (window.muted) {
            return;
          }
          input(it);
          return typeof (ref$ = window.parent).post === 'function' ? ref$.post(it, window.id) : void 8;
        };
        window.reset();
        return window.setInterval(function(){
          return $(".gi-user").each(function(i, x){
            if ($(x).text().match(/cf-tick/)) {
              return $(x).text("");
            }
          });
        }, 1);
      });
    });
  });
}).call(this);
