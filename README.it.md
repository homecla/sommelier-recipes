# Sommelier — catalogo ricette

[English](README.md) · **Italiano**

Ricette (configurazioni pronte) per preparare bottiglie Wine su macOS con
[Sommelier](https://github.com/homecla/sommelier/blob/main/README.it.md). Una ricetta imposta la versione di Windows, installa i
componenti winetricks, applica modifiche al registro e, se serve, scarica e installa un programma.

## Usare il catalogo

Sommelier usa questo catalogo come predefinito. Nell'app: **Ricette → Catalogo online**. Da terminale:

```sh
sommelier catalog                 # elenco
sommelier catalog install steam   # installa (verifica l'impronta SHA-256)
sommelier catalog update          # aggiorna le ricette installate dal catalogo
```

## Proporre una ricetta

1. Aggiungi `recipes/<nome>.preset` (nome: `a-z 0-9 - _`).
2. Controlla che sia valida: `./build-catalog.sh --check`.
3. Apri una pull request. Il workflow la valida e, dopo il merge, rigenera `catalog.json`.

### Formato

```sh
TITLE="Nome"                     # obbligatorio
DESCRIPTION="Cosa fa"            # obbligatorio
NOTES="Consigli per l'utente"
TITLE_EN="…"  DESCRIPTION_EN="…"  NOTES_EN="…"   # traduzioni (anche _IT)
ICON="gamecontroller.fill"       # nome di un simbolo SF
ORDER=50                         # posizione nell'elenco
WINVER="win10"
WINETRICKS="corefonts vcrun2022"
FONT_SMOOTHING=1
REGISTRY='[HKEY_CURRENT_USER\Software\Wine\DllOverrides]
"nome"="native,builtin"'
INSTALLER_URL="https://…/setup.exe"  # solo https
INSTALLER_ARGS="/S"
PROGRAM_NAME="Nome"
PROGRAM_PATH='C:\Program Files\App\app.exe|C:\Program Files (x86)\App\app.exe'
PROGRAM_ARGS="-opzione"
```

Scrivi ogni testo **in inglese e in italiano**. Sommelier mostra la lingua dell'utente e,
se manca la traduzione, usa il valore di base.

Le ricette **non vengono mai eseguite**: Sommelier legge solo le chiavi elencate qui sopra.
Non sono ammessi altri comandi né caratteri speciali della shell negli argomenti. Una ricetta
con `INSTALLER_URL` scarica ed esegue un programma: chi la revisiona deve controllare che
l'indirizzo sia quello ufficiale del produttore.

`catalog.json` è generato automaticamente: non modificarlo a mano.
