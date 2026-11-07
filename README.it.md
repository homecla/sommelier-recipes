# Sommelier — catalogo ricette

[English](README.md) · **Italiano**

Ricette (configurazioni pronte) per preparare bottiglie Wine su macOS con
[Sommelier](https://github.com/homecla/sommelier/blob/main/README.it.md). Una ricetta imposta la versione di Windows, installa i
componenti winetricks, applica modifiche al registro e, se serve, scarica e installa un programma.

## Usare il catalogo

Sommelier usa questo catalogo come predefinito ([guida utente](https://homecla.github.io/sommelier/#it)). Nell'app: **Ricette → Catalogo online**. Da terminale:

```sh
sommelier catalog                 # elenco
sommelier catalog install steam   # installa (verifica l'impronta SHA-256)
sommelier catalog update          # aggiorna le ricette installate dal catalogo
```

## Proporre una ricetta

1. Aggiungi `recipes/<nome>.preset` (nome: `a-z 0-9 - _`).
2. Controlla che sia valida: `./build-catalog.sh --check`.
3. Apri una pull request. Il workflow la valida e, dopo il merge, rigenera `catalog.json`.

Proponendo una ricetta accetti di rilasciarla con licenza **CC0 1.0** (vedi [Licenza](#licenza)).

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
INSTALLER_SHA256="…"                 # facoltativo: 64 cifre esadecimali, l'installer viene rifiutato se diverso
INSTALLER_ARGS="/S"
PROGRAM_NAME="Nome"
PROGRAM_PATH='C:\Program Files\App\app.exe|C:\Program Files (x86)\App\app.exe'
PROGRAM_ARGS="-opzione"
FIXES="steam-webhelper"              # attiva per nome i correttivi integrati in Sommelier
```

Scrivi ogni testo **in inglese e in italiano**. Sommelier mostra la lingua dell'utente e,
se manca la traduzione, usa il valore di base.

Usa `INSTALLER_SHA256` ogni volta che il produttore pubblica un file fisso (un indirizzo con la
versione): Sommelier si rifiuterà di eseguire qualsiasi altra cosa. Omettila solo per gli
indirizzi "ultima versione", come quello di Steam, il cui contenuto cambia nel tempo.

`FIXES` può solo nominare correttivi integrati in Sommelier (oggi: `steam-webhelper`, vedi
[fixes/steam-webhelper](https://github.com/homecla/sommelier/tree/main/fixes/steam-webhelper)).
I loro file arrivano dalle release di Sommelier, compilate dal sorgente da GitHub Actions e
verificate con un'impronta SHA-256 fissata in Sommelier.

Le ricette **non vengono mai eseguite**: Sommelier legge solo le chiavi elencate qui sopra.
Non sono ammessi altri comandi né caratteri speciali della shell negli argomenti. Una ricetta
con `INSTALLER_URL` scarica ed esegue un programma: chi la revisiona deve controllare che
l'indirizzo sia quello ufficiale del produttore.

`catalog.json` è generato automaticamente: non modificarlo a mano.

## Licenza

- **Ricette** (`recipes/`), `catalog.json`, documentazione e workflow sono dedicati al pubblico
  dominio con [CC0 1.0](LICENSE): chiunque può riusarli liberamente, in qualsiasi progetto,
  senza chiedere.
- **Script** (`build-catalog.sh`, `tools/sommelier`) sono distribuiti con licenza
  [GNU AGPL v3.0 o successiva](LICENSES/AGPL-3.0-or-later.txt), come
  [Sommelier](https://github.com/homecla/sommelier/blob/main/README.it.md).

CC0 riguarda solo i file delle ricette. Il software che una ricetta scarica (per esempio
l'installer di Steam di Valve o i componenti Microsoft installati con winetricks) proviene dal
suo produttore ed è soggetto alle sue condizioni di licenza. I nomi dei prodotti sono marchi
dei rispettivi titolari e sono usati solo per descrivere cosa prepara una ricetta.

Ogni file indica la sua licenza nell'intestazione `SPDX-License-Identifier`. I testi completi
sono in [`LICENSES/`](LICENSES/). Il testo legale vincolante è quello inglese.
