z = require \./comp_char_simple.json
moo = {}
for k, v of z
  foo = {}
  for part in (k / '').sort!
    foo[part] = true
  k-prime = (Object.keys(foo).sort! * '')
  moo[k-prime] = v
console.log JSON.stringify moo,,2

