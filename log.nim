#import std/strutils
import std/strformat
import std/json
import std/os
import std/times


var log = %*{"registros":[]}



proc log_arq*(nome:string)=
 if not fileExists(fmt"{nome}.json"):
  writeFile(getCurrentDir()/fmt"{nome}.json", $log)
  echo "1"
 else:
   discard
   
proc add_event*(nome,evento:string)=
 var logs = parseJson(readFile(getCurrentDir()/fmt"{nome}.json"))
 let horas = now().format("yyyy/MM/dd HH:mm:ss")
 logs["registros"].add(%fmt"{horas}, {evento}")
 writeFile(getCurrentDir()/fmt"{nome}.json",logs.pretty())
 
