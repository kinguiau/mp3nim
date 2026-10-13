import random,tables,strformat,strutils,osproc,os
import log
#import sdl2
#import sdl2/mixer


#freeMusic(musica)
#closeAudio()
#sdl2.quit()
#discard playMusic(musica, 0)   # 0 = toca uma vez, -1 = em loop
#discard volumeMusic(96)        # 0 a 128
#if musica.isNil:
 # echo "Falha ao carregar o MP3: " & $getError()
 # discard readLine(stdin)
#let musica = loadMUS("")
echo "Comandos: p = pausar, r = retomar, s = parar, q = sair"
#while true:
 # case stdin.readLine()
 # of "p": pauseMusic()
 # of "r": resumeMusic()
 # of "s": discard haltMusic()
 # of "q": break
 # else: discard
#proc ligar()=
  #if sdl2.init(INIT_AUDIO) != SdlSuccess:
   # echo "Falha ao iniciar SDL: " & $getError()
   # discard readLine(stdin)
 # 44100 Hz, formato padrão, estéreo, buffer de 2048
  #if openAudio(44100, AUDIO_S16LSB, 2, 2048) != 0:
   # echo "Falha ao abrir o áudio: " & $getError()
   # discard readLine(stdin)

template loop_categorias(codigo: untyped) {.dirty.}=
      for genero_musical,lista_artistas in categorias:
        for artista_comparado in lista_artistas:
          codigo
    
template loop_path(caminho:string,codigo: untyped) {.dirty.}=
      for tipo,arquivo in walkDir(caminho):
        if tipo==pcFile:
          let nome_arquivo = extractFilename(arquivo)
          codigo

var 
  categorias = {
    "geek": newSeq[string](),
    "rock": newSeq[string](),
    "japa": newSeq[string](),
    "diferentes": newSeq[string](),
    "O Grilo": newSeq[string]()
  }.toTable()
  
let path = "D:/musica/no_celular"

proc tabelar()=
  for i in categorias.keys:
    for tipo,arquivo in walkDir(path/i):
      if tipo==pcDir and lastPathPart(arquivo) notin categorias[i]:
        categorias[i].add(lastPathPart(arquivo))
tabelar()

for i in categorias.keys:
  echo i,categorias[i]

proc listar()=
  for i in categorias.keys:
    echo i & ": \n"
    for j in categorias[i]:
      echo "--" & j
  
listar()
proc tocar_solo()=
  discard
proc tocar_playlist()=
  discard

discard readLine(stdin)