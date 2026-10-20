var
  tp = Taskpool.new(numThreads = 2)   # 2: uma thread fica presa no readLine
  entrada: Flowvar[string]
  pendente = false                    # Flowvar não tem isNil, então uso uma flag

# envolve o readLine para o spawn não se confundir com a sobrecarga
proc lerStdin(): string =
  {.cast(gcsafe).}:
    result = readLine(stdin)

proc musica_comandos()=
  if not pendente:
    entrada = tp.spawn lerStdin()
    pendente = true

  if entrada.isReady:
    let cmd = sync(entrada)           # equivale ao ^entrada
    pendente = false
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
    else: 
      discard
  sleep(100)

proc lerLinha(): string =
  if pendente:
    result = sync(entrada)            # bloqueia até a linha pendente chegar
    pendente = false
  else:
    result = readLine(stdin)