osascript -e 'tell app "Terminal"
try
  «event BATTchck»
  set res to "yes"
on error msg number num
  set res to "no"
end try
res
end tell'
