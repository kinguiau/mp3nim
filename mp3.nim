import random,tables,strformat,strutils,os,json,terminal
import sdl2,sdl2/mixer




#iniciar
randomize()
if sdl2.init(INIT_AUDIO) != SdlSuccess:
  echo "Falha ao iniciar SDL: " & $getError()
  discard readLine(stdin)
 # 44100 Hz, formato padrão, estéreo, buffer de 2048
if openAudio(44100, MIX_DEFAULT_FORMAT, 2, 2048) != 0:
  echo "Falha ao abrir o áudio: " & $getError()
  discard readLine(stdin)
var volume: int = 96
discard volumeMusic(volume.cint()) # 0 a 128
var aleat = true

#template
template loop_categorias(codigo: untyped) {.dirty.}=
      for genero_musical in categorias.keys:
        for artista_comparado in categorias[genero_musical]:
          codigo
template loop_path(caminho:string,codigo: untyped) {.dirty.}=
      for tipo,arquivo in walkDir(caminho):
        if tipo==pcFile:
          codigo


#json
if not fileExists("mp3.json"):
  writeFile(getCurrentDir()/"mp3.json",$(%*{"categorias":[], "path":"","historico":[]}))
let 
  json_info = parseJson(readFile("mp3.json"))
  path = getStr(json_info["path"])

var historico = newSeq[string]()
for i in 0..(json_info["historico"].len()-1):
    historico.add(getStr(json_info["historico"][i]))

var categorias=initTable[string, seq[string]]()
for i in json_info["categorias"]:
  categorias[i.getStr()] = newSeq[string]()


#segunda thread
var 
  thread: Thread[void]
  comandos:Channel[string]
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
  
createThread(thread,leitor)
proc lerLinha(): string = comandos.recv()


# carregar
proc tabelar()=
  for i in categorias.keys:
    for tipo,arquivo in walkDir(path/i):
      if tipo==pcDir and lastPathPart(arquivo) notin categorias[i]:
        categorias[i].add(lastPathPart(arquivo))
tabelar()
for i in categorias.keys:
  echo i,categorias[i]  
styledEcho fgGreen, """
  comandos:
    playlist
    tocar
    aleat
    listar
    aumentar
    diminuir
    voltar
    passar
    sair"""

    

# chamadas
var 
  id: int = historico.len() - 1
  passadas = 0
  no_limite = false


proc musica_comandos(musica:string)

proc toque(atual:string,salvar:bool)=
    styledEcho fgMagenta, lastPathPart(atual)
  
    let musica = loadMUS(atual.cstring())
    discard playMusic(musica,0) # 0 = toca uma vez, -1 = em loop
    if salvar:
      json_info["historico"].add(%atual)
      writeFile(getCurrentDir()/"mp3.json",json_info.pretty())
    
  
    while (playingMusic() != 0):
      musica_comandos(atual)

proc aumentar_volume()=
  if volume < 128:
    volume += 16
    discard volumeMusic(volume.cint())
    echo volume

proc diminuir_volume()=
  if volume > 0:
    volume -= 16
    discard volumeMusic(volume.cint())
    echo volume
      
proc listar()=
  for i in categorias.keys:
    echo i & ": \n"
    for j in categorias[i]:
      echo "--" & j

proc passar()=
  for i in (historico.len())..(json_info["historico"].len() - 1):
    historico.add(getStr(json_info["historico"][i]))

  discard haltMusic()
  passadas -= 1  

  echo fmt"{id},{passadas}"

  let cancao = historico[(id - passadas)]  

  echo "333"

  toque(cancao,false)

proc voltar()=
  if historico.len()<json_info["historico"].len():
    for i in historico.len()..(json_info["historico"].len() - 1):
      historico.add(getStr(json_info["historico"][i]))
    id = historico.len() - 1

  if (id - passadas) > 0:
    passadas += 1
  echo fmt"{id},{passadas}"
  
  echo "222"
  if (id - passadas) >= 0:
    if (id - passadas) == 0 and no_limite:
      echo "limite"
  
    else:
      if (id - passadas) == 0:
        no_limite = true

      let cancao = historico[(id - passadas)]
      echo cancao

      discard haltMusic()
      toque(cancao,false)  

      if (playingMusic() == 0):
        for i in 0..passadas:
          passar()
    
proc musica_comandos(musica:string) =
  
  let (estavel, cmd) = comandos.tryRecv()   # não bloqueia
  if estavel:
    if cmd == "sair":
      system.quit()
    elif cmd == "pausar": 
      pauseMusic()
    elif cmd == "despausar":
      resumeMusic()
    elif cmd == "aumentar":
      aumentar_volume()
    elif cmd == "diminuir":  
      diminuir_volume()
    elif cmd == "passar":
      if passadas <= 0:
        echo "limite"
        discard haltMusic()
      else:
        passar()

    elif cmd == "voltar":
        voltar()
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
          toque(arquivo,true)
                      
              
proc tocar_playlist(vmz:string)=
  styledEcho fgYellow, fmt"artista:{vmz}"
  let escolhido_artista = vmz
  var 
    genero: string
    artista: string
    playlist:seq[string]= @[]


  loop_categorias:
    if escolhido_artista.toLower() in artista_comparado.toLower():
      genero = genero_musical
      artista = artista_comparado

  loop_path(path/genero/artista):    
    if arquivo notin playlist:
        playlist.add(arquivo)


  if aleat: 
    shuffle(playlist)
    for i in playlist:
      echo "000"
      toque(i,true)
        
  elif not aleat:
    for i in playlist:
      echo "111"
      toque(i,true)
      
tocar_playlist("vmz")

while true:
  echo "<----------------->"
  var texto = lerLinha()
  if texto == "tocar":
    tocar_solo()
  elif texto == "playlist":
    styledEcho fgYellow, "VVV"
    #tocar_playlist(lerLinha())
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