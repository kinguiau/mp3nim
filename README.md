# 🎵 mp3nim

Um player de música MP3 de linha de comando escrito em [Nim](https://nim-lang.org/), com suporte a categorias por gênero, busca por artista e reprodução aleatória — usando SDL2 e SDL2_mixer como backend de áudio.

---

## 📋 Funcionalidades

- Organização de músicas por **gênero/categoria** (geek, rock, japa, diferentes, O Grilo)
- **Busca por artista** com correspondência parcial (case-insensitive)
- Reprodução de uma **música específica** por nome parcial
- Reprodução de **playlist completa** de um artista
- Modo **aleatório** (shuffle) ativável/desativável em tempo real
- **Log de eventos** em arquivo JSON com timestamp

---

## 🗂️ Estrutura esperada de pastas

O programa espera que as músicas estejam organizadas no seguinte formato:

```
D:/musica/no_celular/
├── geek/
│   ├── NomeArtista1/
│   │   ├── musica1.mp3
│   │   └── musica2.mp3
│   └── NomeArtista2/
├── rock/
│   └── ...
├── japa/
│   └── ...
├── diferentes/
│   └── ...
└── O Grilo/
    └── ...
```

> **Nota:** O caminho base está definido no código como `D:/musica/no_celular`. Para mudar, edite a variável `path` em `mp3.nim`.

---

## 🛠️ Dependências

| Dependência | Versão | Descrição |
|---|---|---|
| [Nim](https://nim-lang.org/) | ≥ 1.6 | Linguagem de programação |
| [SDL2](https://www.libsdl.org/) | 2.x | Backend de áudio |
| [SDL2_mixer](https://wiki.libsdl.org/SDL2_mixer/FrontPage) | 2.x | Decodificação e reprodução de MP3 |
| [sdl2 (nimble)](https://github.com/nim-lang/sdl2) | — | Bindings SDL2 para Nim |

Os arquivos `SDL2.dll` e `SDL2_mixer.dll` já estão incluídos no repositório para Windows.

---

## 🚀 Como compilar

1. Instale o [Nim](https://nim-lang.org/install.html)
2. Instale os bindings SDL2 via Nimble:
   ```bash
   nimble install sdl2
   ```
3. Compile o player:
   ```bash
   nim c -r mp3.nim
   ```
4. (Opcional) Compile o módulo de log:
   ```bash
   nim c log.nim
   ```

---

## ▶️ Como usar

Execute o programa compilado:

```bash
./mp3.exe
```

Ao iniciar, o programa carrega a biblioteca de músicas e exibe os artistas por categoria. Em seguida, aguarda comandos no terminal:

| Comando | Descrição |
|---|---|
| `tocar` | Busca um artista e toca uma música específica |
| `playlist` | Busca um artista e toca todas as suas músicas |
| `aleat` | Alterna o modo aleatório (shuffle) ligado/desligado |

### Exemplo de uso — tocar uma música

```
<----------------->
tocar
artista
metallica
musica
master
```

O programa busca qualquer artista que contenha "metallica" e qualquer arquivo que contenha "master" no nome, e inicia a reprodução.

### Exemplo de uso — playlist aleatória

```
<----------------->
playlist
pink floyd
```

Toca todas as músicas do artista encontrado em ordem aleatória (se `aleat` estiver ativo).

---

## 📁 Arquivos do projeto

| Arquivo | Descrição |
|---|---|
| `mp3.nim` | Código principal do player |
| `log.nim` | Módulo de logging em JSON |
| `mp3.exe` | Executável compilado para Windows |
| `log.exe` | Executável do módulo de log |
| `SDL2.dll` | Biblioteca SDL2 para Windows |
| `SDL2_mixer.dll` | Biblioteca SDL2_mixer para Windows |

---

## 📝 Módulo de Log (`log.nim`)

O módulo `log.nim` oferece duas funções para registrar eventos em um arquivo JSON:

```nim
log_arq("nome_do_log")          # Cria o arquivo de log se não existir
add_event("nome_do_log", "evento ocorreu")  # Adiciona um evento com timestamp
```

O arquivo gerado tem o formato:

```json
{
  "registros": [
    "2026/10/16 14:32:00, evento ocorreu"
  ]
}
```

---

## ⚙️ Configuração

Para adaptar o programa ao seu ambiente, edite `mp3.nim`:

```nim
# Linha 16 — caminho base das músicas
let path = "D:/musica/no_celular"

# Linha 19 — volume inicial (0 a 128)
discard volumeMusic(96)

# Linha 4 — modo aleatório ligado por padrão
var aleat = true
```

---

## 📄 Licença

Distribuído sob a licença MIT. Veja o arquivo `LICENSE` para mais detalhes.
