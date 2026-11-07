# Sommelier — recipe catalog

**English** · [Italiano](README.it.md)

Recipes (ready-made configurations) for preparing Wine bottles on macOS with
[Sommelier](https://github.com/homecla/sommelier). A recipe sets the Windows version, installs winetricks components,
applies registry tweaks and, when needed, downloads and installs a program.

## Using the catalog

Sommelier uses this catalog by default ([user guide](https://homecla.github.io/sommelier/)). In the app: **Recipes → Online Catalog**. From the terminal:

```sh
sommelier catalog                 # list
sommelier catalog install steam   # install (verifies the SHA-256 fingerprint)
sommelier catalog update          # update recipes installed from the catalog
```

## Contributing a recipe

1. Add `recipes/<name>.preset` (name: `a-z 0-9 - _`).
2. Check that it is valid: `./build-catalog.sh --check`.
3. Open a pull request. The workflow validates it, and after the merge it regenerates `catalog.json`.

By contributing a recipe you agree to release it under **CC0 1.0** (see [License](#license)).

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
FIXES="steam-webhelper"              # enable Sommelier's built-in fixes by name
```

Write every text in **both English and Italian**. Sommelier shows the user's language and
falls back to the base value.

`FIXES` can only name fixes built into Sommelier (today: `steam-webhelper`, see
[fixes/steam-webhelper](https://github.com/homecla/sommelier/tree/main/fixes/steam-webhelper)).
Their files come from Sommelier's own releases, built from source by CI and checked with a
SHA-256 pinned in Sommelier.

Recipes are **never executed**: Sommelier reads only the keys listed above. Other commands
and shell special characters in arguments are not allowed. A recipe with `INSTALLER_URL`
downloads and runs a program, so reviewers must check that the URL is the vendor's
official one.

`catalog.json` is generated automatically: do not edit it by hand.

## License

- **Recipes** (`recipes/`), `catalog.json`, the documentation and the workflow are dedicated to
  the public domain under [CC0 1.0](LICENSE): anyone can reuse them freely, in any
  project, without asking.
- **Scripts** (`build-catalog.sh`, `tools/sommelier`) are released under the
  [GNU AGPL v3.0 or later](LICENSES/AGPL-3.0-or-later.txt), like
  [Sommelier](https://github.com/homecla/sommelier).

CC0 covers only the recipe files themselves. The software a recipe downloads (for example
Valve's Steam installer or Microsoft components installed through winetricks) comes from its
vendor and is subject to the vendor's license terms. Product names are trademarks of their
owners and are used only to describe what a recipe sets up.

Each file states its license in the `SPDX-License-Identifier` header. The full texts are in
[`LICENSES/`](LICENSES/).
