# 🎵 mp3nim

Um player de música MP3 de linha de comando escrito em [Nim](https://nim-lang.org/), com suporte a categorias por gênero, busca por artista e reprodução aleatória — usando SDL2 e SDL2_mixer como backend de áudio.

---

## 📋 Funcionalidades

- Organização de músicas por **gênero/categoria** configurável via `mp3.json`
- **Busca por artista** com correspondência parcial (case-insensitive)
- Reprodução de uma **música específica** por nome parcial
- Reprodução de **playlist completa** de um artista
- Modo **aleatório** (shuffle) ativável/desativável em tempo real
- **Controle de volume** em tempo real (aumentar/diminuir)
- **Pausar e despausar** a música atual
- **Navegar pelo histórico** — voltar e avançar músicas já tocadas
- **Listar** todos os artistas por categoria
- **Histórico persistente** de reprodução salvo no `mp3.json`
- **Log de eventos** em arquivo JSON com timestamp

---

## 🗂️ Estrutura esperada de pastas

O programa espera que as músicas estejam organizadas da seguinte forma:

```
<path configurado no mp3.json>/
├── genero1/
│   ├── NomeArtista1/
│   │   ├── musica1.mp3
│   │   └── musica2.mp3
│   └── NomeArtista2/
├── genero2/
│   └── ...
└── genero3/
    └── ...
```

Os gêneros/categorias são definidos no arquivo `mp3.json`.

---

## ⚙️ Configuração — mp3.json

Antes de usar, configure o arquivo `mp3.json` na raiz do projeto:

```json
{
  "categorias": ["rock", "japa", "geek"],
  "path": "D:/musica/no_celular",
  "historico": []
}
```

| Campo | Descrição |
|---|---|
| `categorias` | Lista de subpastas/gêneros dentro do `path` |
| `path` | Caminho base onde estão as pastas de gêneros |
| `historico` | Histórico de músicas tocadas (gerenciado automaticamente) |

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

Ao iniciar, o programa carrega a biblioteca de músicas a partir do `mp3.json` e exibe os artistas por categoria. Em seguida, aguarda comandos no terminal.

---

## 🎮 Comandos

### Comandos do menu principal

| Comando | Descrição |
|---|---|
| `tocar` | Busca um artista e toca uma música específica |
| `playlist` | Busca um artista e toca todas as suas músicas |
| `aleatorio` | Alterna o modo aleatório (shuffle) ligado/desligado |
| `listar` | Lista todos os artistas organizados por categoria |
| `aumentar` | Aumenta o volume em 16 unidades (máx. 128) |
| `diminuir` | Diminui o volume em 16 unidades (mín. 0) |
| `sair` | Encerra o programa |

### Comandos durante a reprodução

Estes comandos funcionam enquanto uma música está tocando:

| Comando | Descrição |
|---|---|
| `pausar` | Pausa a música atual |
| `despausar` | Retoma a música pausada |
| `passar` | Avança para a próxima música no histórico |
| `voltar` | Volta para a música anterior no histórico |
| `aumentar` | Aumenta o volume |
| `diminuir` | Diminui o volume |
| `sair` | Para a reprodução e encerra o programa |

---

## 📖 Exemplos de uso

### Tocar uma música específica

```
<----------------->
tocar
artista
metallica
musica
master
```

Busca qualquer artista que contenha "metallica" e qualquer arquivo que contenha "master" no nome, e inicia a reprodução.

### Tocar playlist de um artista

```
<----------------->
playlist
pink floyd
```

Toca todas as músicas do artista encontrado. Se o modo aleatório estiver ativo, a ordem é embaralhada.

### Listar artistas

```
<----------------->
listar
```

Exibe todos os artistas agrupados por categoria/gênero.

### Controlar volume

```
<----------------->
aumentar
```

Aumenta o volume atual em 16 unidades e exibe o valor novo.

---

## 📁 Arquivos do projeto

| Arquivo | Descrição |
|---|---|
| `mp3.nim` | Código principal do player |
| `log.nim` | Módulo de logging em JSON |
| `mp3.json` | Configuração de categorias, caminho e histórico |
| `mp3.exe` | Executável compilado para Windows |
| `log.exe` | Executável do módulo de log |
| `SDL2.dll` | Biblioteca SDL2 para Windows |
| `SDL2_mixer.dll` | Biblioteca SDL2_mixer para Windows |

---

## 📝 Módulo de Log (`log.nim`)

O módulo `log.nim` registra eventos automaticamente durante o uso do player em um arquivo JSON:

```nim
log_arq("nome_do_log")                      # Cria o arquivo de log se não existir
add_event("nome_do_log", "evento ocorreu")  # Adiciona um evento com timestamp
```

O arquivo gerado tem o formato:

```json
{
  "registros": [
    "2026/10/16 14:32:00, iniciar",
    "2026/10/16 14:32:05, tocando Master of Puppets.mp3",
    "2026/10/16 14:35:12, passar, música atual: Fade to Black.mp3"
  ]
}
```

Eventos registrados automaticamente: iniciar, tabelar, tocar, playlist, passar, voltar, pausar, despausar, aumentar/diminuir volume, listar e sair.

---

## ⚙️ Ajustes no código

Para modificar comportamentos padrão, edite `mp3.nim`:

```nim
# Volume inicial (0 a 128)
var volume: int = 96

# Modo aleatório ligado por padrão
var aleatorio: bool = true
```

---

## 📄 Licença

Distribuído sob a licença MIT. Veja o arquivo `LICENSE` para mais detalhes.
