# Sommelier — recipe catalog

**English** · [Italiano](README.it.md)

Recipes (ready-made configurations) for preparing Wine bottles on macOS with
[Sommelier](https://github.com/homecla/sommelier). A recipe sets the Windows version, installs winetricks components,
applies registry tweaks and, when needed, downloads and installs a program.

## Using the catalog

Sommelier uses this catalog by default. In the app: **Recipes → Online Catalog**. From the terminal:

```sh
sommelier catalog                 # list
sommelier catalog install steam   # install (verifies the SHA-256 fingerprint)
sommelier catalog update          # update recipes installed from the catalog
```

## Contributing a recipe

1. Add `recipes/<name>.preset` (name: `a-z 0-9 - _`).
2. Check that it is valid: `./build-catalog.sh --check`.
3. Open a pull request. The workflow validates it, and after the merge it regenerates `catalog.json`.

### Format

```sh
TITLE="Name"                     # required
DESCRIPTION="What it does"       # required
NOTES="Tips for the user"
TITLE_EN="…"  DESCRIPTION_EN="…"  NOTES_EN="…"   # translations (also _IT)
ICON="gamecontroller.fill"       # SF Symbol name
ORDER=50                         # position in the list
WINVER="win10"
WINETRICKS="corefonts vcrun2022"
FONT_SMOOTHING=1
REGISTRY='[HKEY_CURRENT_USER\Software\Wine\DllOverrides]
"name"="native,builtin"'
INSTALLER_URL="https://…/setup.exe"  # https only
INSTALLER_ARGS="/S"
PROGRAM_NAME="Name"
PROGRAM_PATH='C:\Program Files\App\app.exe|C:\Program Files (x86)\App\app.exe'
PROGRAM_ARGS="-option"
```

Write every text in **both English and Italian**. Sommelier shows the user's language and
falls back to the base value.

Recipes are **never executed**: Sommelier reads only the keys listed above. Other commands
and shell special characters in arguments are not allowed. A recipe with `INSTALLER_URL`
downloads and runs a program, so reviewers must check that the URL is the vendor's
official one.

`catalog.json` is generated automatically: do not edit it by hand.
