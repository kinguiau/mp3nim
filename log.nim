#import std/strutils
import std/strformat
import std/json
import std/os
import std/times
import std/terminal





proc log_arq*(nome: string): int =
  if not fileExists(getCurrentDir()/fmt"{nome}.json"):
    let log = %*{"registros":[]}
    writeFile(getCurrentDir()/fmt"{nome}.json", $log)
    return 1
  elif fileExists(getCurrentDir()/fmt"{nome}.json"):
    return 1
  else:
    styledEcho fgRed, "ERRO: erro de criação"
    return 0
    
proc add_event*(nome, evento: string): int =
  if fileExists(getCurrentDir()/fmt"{nome}.json"):
    var logs = parseJson(readFile(getCurrentDir()/fmt"{nome}.json"))
    let horas = now().format("yyyy/MM/dd HH:mm:ss")
    logs["registros"].add(%fmt"{horas}, {evento}")
    writeFile(getCurrentDir()/fmt"{nome}.json",logs.pretty())
    return 1
  else:
    styledEcho fgRed, "ERRO: json inexistente"
    return 0