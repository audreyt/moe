<- $

origin = "http://127.0.0.1:8888/"
url =  'https://goinstant.net/poga/yhd2013-moe-users'
window.id = \users
window.addEventListener("message", -> window.input it.data, false);

$(document).on \click, \span, ->
  console.log $(it.target).text!
  window.output $(it.target).text!

connection = new goinstant.Connection(url)
<- connection.connect
room = connection.room("game")
<- room.join
userList = new goinstant.widgets.UserList {room: room, collapsed: false, position: 'left', userOptions: false}
do
  <- userList.initialize
  console.log it if it

window.reset = -> 
  room.self!.key('displayName').set ""
window.input = ->
  text = it
  do
    (err, v, ctx) <- room.self!.key('displayName').get
    connect.log err if err
    console.log("v=#v")
    room.self!.key('displayName').set(text)
window.output = ->
  return if window.muted
  input it
  window.top.postMessage(it, origin)

window.reset!
