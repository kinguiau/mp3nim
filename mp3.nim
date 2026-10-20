import random,tables,strformat,strutils,os,json,terminal
import sdl2,sdl2/mixer

randomize()
enableTrueColors()


if not fileExists("mp3.json"):
  writeFile(getCurrentDir()/"mp3.json",$(%*{"categorias":[], "path":""}))
let json_info = parseJson(readFile("mp3.json"))



var 
  categorias=initTable[string, seq[string]]()
  aleat = true
  volume: int = 96
  
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
discard volumeMusic(volume.cint()) # 0 a 128

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

proc aumentar_volume()=
  if volume<128:
    volume= volume + 16
    discard volumeMusic(volume.cint())
    echo volume
proc diminuir_volume()=
  if volume>0:
    volume = volume - 16
    discard volumeMusic(volume.cint())
    echo volume
    
styledEcho fgGreen, """
comandos:
  playlist
  tocar
  aleat
  listar
  aumentar
  diminuir"""
  
proc listar()=
  for i in categorias.keys:
    echo i & ": \n"
    for j in categorias[i]:
      echo "--" & j


var comandos:Channel[string]
comandos.open()

proc leitor() {.thread.} =
  while true:
    var linha:string
    try:
      linha = readLine(stdin)
    except EOFError:
      linha = "sair"
    comandos.send(linha)
    if linha == "sair":
      break
var thread: Thread[void]
createThread(thread,leitor)
proc lerLinha(): string = comandos.recv()
      
proc musica_comandos() =
  let (estavel, cmd) = comandos.tryRecv()   # não bloqueia
  if estavel:
    if cmd == "pausar": 
      pauseMusic()
    elif cmd == "despausar":
      resumeMusic()
    elif cmd == "passar":
      discard haltMusic()
    elif cmd == "aumentar":
      aumentar_volume()
    elif cmd == "diminuir":  
      diminuir_volume()
  sleep(50)
      




      
proc tocar_solo()=
  echo "artista"
  let artista = lerLinha()
  echo "musica"
  let musica = lerLinha()
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
          let musica = loadMUS(arquivo.cstring())
          discard playMusic(musica, 0) # 0 = toca uma vez, -1 = em loop
       
          while (playingMusic() != 0):
            musica_comandos()
            
              
proc tocar_playlist()=
  styledEcho fgYellow, "artista:"
  let escolhido_artista = lerLinha()
  var 
    genero: string
    artista: string
    playlist:seq[string]= @[]
    atual: string

  loop_categorias:
    if escolhido_artista.toLower() in artista_comparado.toLower():
      genero = genero_musical
      artista = artista_comparado
  loop_path(path/genero/artista):    
    if arquivo notin playlist:
        playlist.add(arquivo)
  if aleat:  
    for i in 0..playlist.len():
      if (playingMusic()==0):      
        #styledEcho fgBlue, "000"
        echo "000"
        atual = playlist.sample()
        let musica = loadMUS(atual.cstring())
        discard playMusic(musica,0)

        styledEcho bgGreen, fgMagenta, lastPathPart(atual)
        while (playingMusic()!=0):
          musica_comandos()
        sleep(250)
        playlist.delete(playlist.find(atual))
  
  elif not aleat:
    echo "111"
    for i in playlist:
      let musica = loadMUS(i.cstring())
      discard playMusic(musica,0)
      while (playingMusic()!=0):
        sleep(10000)
      sleep(250)
      
#tocar_playlist()

while true:
  echo "<----------------->"
  var texto = lerLinha()
  if texto == "tocar":
    tocar_solo()
  elif texto == "playlist":
    tocar_playlist()
  elif texto == "aleat":
    aleat = not aleat
  elif texto == "listar":
    listar()
  elif texto == "aumentar":
    aumentar_volume()
  elif texto == "diminuir":
    diminuir_volume()



closeAudio()
sdl2.quit()



#if musica.isNil:
  # echo "Falha ao carregar o MP3: " & $getError()
  # discard readLine(stdin)