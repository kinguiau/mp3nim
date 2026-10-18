import random,tables,strformat,strutils,os,json
import sdl2,sdl2/mixer

randomize()

#if "mp3.json"
let json_info = parseJson(readFile("mp3.json"))



var 
  categorias=initTable[string, seq[string]]()
  aleat = true

for i in json_info["categorias"]:
  categorias[i.getStr()] = newSeq[string]()


let path = getStr(json_info["path"]) 


if sdl2.init(INIT_AUDIO) != SdlSuccess:
  echo "Falha ao iniciar SDL: " & $getError()
  discard readLine(stdin)
 # 44100 Hz, formato padrão, estéreo, buffer de 2048

if openAudio(44100, MIX_DEFAULT_FORMAT, 2, 2048) != 0:
  echo "Falha ao abrir o áudio: " & $getError()
  discard readLine(stdin)
discard volumeMusic(96) # 0 a 128

template loop_categorias(codigo: untyped) {.dirty.}=
      for genero_musical in categorias.keys:
        for artista_comparado in categorias[genero_musical]:
          codigo
    
template loop_path(caminho:string,codigo: untyped) {.dirty.}=
      for tipo,arquivo in walkDir(caminho):
        if tipo==pcFile:
          
          codigo


proc tabelar()=
  for i in categorias.keys:
    for tipo,arquivo in walkDir(path/i):
      if tipo==pcDir and lastPathPart(arquivo) notin categorias[i]:
        categorias[i].add(lastPathPart(arquivo))
tabelar()

for i in categorias.keys:
  echo i,categorias[i]

echo """
comandos:
  playlist
  tocar
  aleat
  listar"""
  
proc listar()=
  for i in categorias.keys:
    echo i & ": \n"
    for j in categorias[i]:
      echo "--" & j
  
proc tocar_solo()=
  echo "artista"
  let artista = readLine(stdin)
  echo "musica"
  let musica = readLine(stdin)
  var 
    escolhido_artista = false
    escolhido_musica = false

  loop_categorias:
    if (artista.toLower() in artista_comparado.toLower()) and (not escolhido_artista):
      escolhido_artista = true
      echo "\n" & artista_comparado
    
      loop_path(path/genero_musical/artista_comparado):
        let nome_arquivo = extractFilename(arquivo)
        if (musica.toLower() in nome_arquivo.toLower()) and (not escolhido_musica):  
          escolhido_musica = true
          echo nome_arquivo
       
          discard playMusic(loadMUS(arquivo.cstring()), 0) # 0 = toca uma vez, -1 = em loop
       
          while (playingMusic() != 0):
            for i in 1..3:
              stdout.write('.')
              sleep(2000)
            
            stdout.write("\r\27[2K") #\r — volta o cursor para o início da linha. \27[2K — apaga a linha inteira. flushFile() — força a atualização do terminal.
            stdout.flushFile() #stdout.write("\27[5D"). Move o cursor 5 posições para trás. stdout.write("\27[5P") Apaga 5 caracteres          
            sleep(2000)
            
            
proc tocar_playlist()=
  echo "artista"
  let escolhido_artista = readLine(stdin)
  var 
    genero: string
    artista: string
    playlist:seq[string]= @[]
    atual: string

  loop_categorias:
    if escolhido_artista.toLower() in artista_comparado.toLower():
      genero = genero_musical
      artista = artista_comparado

  if aleat:  
    loop_path(path/genero/artista):
      if arquivo notin playlist:
        playlist.add(arquivo)

    for i in 0..playlist.len():
      if (playingMusic()==0):      
        echo "000"

        #echo playlist.len()

        atual = playlist.sample()

        discard playMusic(loadMUS(atual.cstring()),0)

        echo lastPathPart(atual)

        while (playingMusic()!=0):
          sleep(1000)
        
        playlist.delete(playlist.find(atual))
        
  elif not aleat:
    echo "111"
    loop_path(path/genero/artista):
      if arquivo notin playlist:
        playlist.add(arquivo)
    for i in playlist:    
      discard playMusic(loadMUS(i.cstring()),0)
      while (playingMusic()!=0):
       sleep(1000) 



while true:
  echo "<----------------->"
  var texto = readLine(stdin)
  if texto == "tocar":
    tocar_solo()
  elif texto == "playlist":
    tocar_playlist()
  elif texto == "aleat":
    aleat = not aleat
  elif texto == "listar":
    listar()



closeAudio()
sdl2.quit()

#while true:
 # case stdin.readLine()
 # of "p": pauseMusic()
 # of "r": resumeMusic()
 # of "s": discard haltMusic()
 # of "q": break
 # else: discard
#if musica.isNil:
  # echo "Falha ao carregar o MP3: " & $getError()
  # discard readLine(stdin)