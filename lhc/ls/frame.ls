window.addEventListener \message, (event) ->
  console.log event.data
# prepare window object
frame = document.getElementById \lhc
win = frame.contentWindow or frame.contentDocument
win = win.getParentNode! if not win.document
# post chars
win.postMessage $(\#in).val!, "http://127.0.0.1:8888/"