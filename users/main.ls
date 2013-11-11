<- $

origin = "http://direct.moedict.tw/"
url =  'https://goinstant.net/poga/yhd2013-moe-users'
window.id = \users
#window.addEventListener("message", -> window.input it.data, false);

$(document).on \click, \span, ->
  window.output $(it.target).text!

connection = new goinstant.Connection(url)
<- connection.connect
room = connection.room("game")
<- room.join
userList = new goinstant.widgets.UserList {room: room, collapsed: false, position: 'left', userOptions: false}

window.reset = ->
  room.self!.key('displayName').set '萌'
window.input = ->
  text = it
  do
    (err, v, ctx) <- room.self!.key('displayName').get
    connect.log err if err
    room.self!.key('displayName').set("#text #v")
window.output = ->
  return if window.muted
  input it
  # window.top.postMessage(it, origin)
  window.parent.post? it, window.id

<- userList.initialize!
window.reset!
window.setInterval ->
  $(".gi-user").each (i,x) ->
    if $(x).text!.match(/cf-tick/)
      $(x).text("")
  $('.gi-name:not(.segmented)').each ->
    $(@).addClass \segmented
    $(@).find('span').hide!
    for seg in $(@).text! / /\s+/ | seg is /[^\s.a-zA-Z]/
      $(@).append($('<span/>').text seg)
, 100ms
