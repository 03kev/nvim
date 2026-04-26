# Neovim Config

Configurazione Neovim modulare basata su `lazy.nvim`, con bootstrap minimale, plugin spec separate per area e una distinzione netta tra:

- moduli `core` caricati subito
- plugin caricati da `lazy.nvim`
- tool di sviluppo gestiti da `Mason`
- formatter e linter dichiarati esplicitamente

L'obiettivo del setup non e' avere "tutto dappertutto", ma mantenere un punto di ingresso semplice, moduli piccoli e un flusso prevedibile quando si aggiungono nuove parti.

## Bootstrap E Struttura

L'entrypoint e' [`init.lua`](./init.lua):

1. carica `myconf.core`
2. bootstrap di `lazy.nvim` e import delle plugin spec
3. applica tema e palette
4. attiva la winbar custom

In pratica il flusso e' questo:

```text
init.lua
├── myconf.core
│   ├── editor/options.lua
│   ├── ui/tabline.lua
│   ├── mappings/*
│   ├── cmd/*
│   └── events/*
├── myconf.lazy
│   ├── bootstrap lazy.nvim
│   ├── import myconf.plugins
│   └── import myconf.plugins.lsp
├── myconf.theme.theme
└── myconf.ui.winbar
```

Le directory principali sono:

- [`lua/configuration.lua`](./lua/configuration.lua): toggle e valori globali del setup
- [`lua/myconf/core`](./lua/myconf/core): opzioni, mapping, comandi e autocmd caricati eagerly
- [`lua/myconf/plugins`](./lua/myconf/plugins): plugin spec generali per `lazy.nvim`
- [`lua/myconf/plugins/lsp`](./lua/myconf/plugins/lsp): plugin spec per LSP e Mason
- [`lua/myconf/theme`](./lua/myconf/theme): palette, tema e utility legate ai colori
- [`lua/myconf/ui`](./lua/myconf/ui): componenti UI custom fuori dai plugin
- [`lazy-lock.json`](./lazy-lock.json): versioni pin dei plugin

## Come Vengono Caricati I Moduli

### Moduli `core`

I moduli `core` non sono registrati a mano uno per uno: vengono scoperti automaticamente da [`lua/myconf/core/utils/modules.lua`](./lua/myconf/core/utils/modules.lua).

Questo vale per:

- [`lua/myconf/core/mappings`](./lua/myconf/core/mappings)
- [`lua/myconf/core/cmd`](./lua/myconf/core/cmd)
- [`lua/myconf/core/events`](./lua/myconf/core/events)

Ogni file `.lua` della directory, escluso `init.lua`, viene caricato automaticamente. Se il modulo esporta:

- una tabella con `setup()`, viene chiamato `setup()`
- una funzione, viene eseguita direttamente

Questo significa che per aggiungere un nuovo mapping o un nuovo comando spesso basta creare un nuovo file nella directory giusta.

### Plugin con `lazy.nvim`

Il bootstrap di `lazy.nvim` vive in [`lua/myconf/lazy.lua`](./lua/myconf/lazy.lua). Al primo avvio:

- se `lazy.nvim` non esiste in `stdpath("data")`, viene clonato con `git`
- il runtime path viene aggiornato
- `lazy` importa tutte le plugin spec da `myconf.plugins` e `myconf.plugins.lsp`

Ogni file dentro quelle directory ritorna una spec valida per `lazy.nvim`. Il pattern usato qui e':

- un file per plugin o per area piccola
- `event`, `ft`, `cmd` o `keys` per lazy-loading quando possibile
- `dependencies` dichiarate localmente nella spec
- `opts` o `config` direttamente nel file del plugin

Esempi:

- [`lua/myconf/plugins/telescope.lua`](./lua/myconf/plugins/telescope.lua)
- [`lua/myconf/plugins/nvim-cmp.lua`](./lua/myconf/plugins/nvim-cmp.lua)
- [`lua/myconf/plugins/lsp/lspconfig.lua`](./lua/myconf/plugins/lsp/lspconfig.lua)

## Moduli Più Importanti

### Config globale

[`lua/configuration.lua`](./lua/configuration.lua) e' il posto giusto per:

- toggle UI come winbar, smooth scrolling e backdrop
- valori piccoli ma globali come il numero massimo di split
- scelta del tema (`dark` o `light`)
- override dei binari esterni in `conf.external`

La funzione `ui.theme()` legge anche `NVIM_THEME`, quindi puoi forzare il tema da shell:

```sh
NVIM_THEME=light nvim
```

Per i binari esterni puoi anche usare variabili ambiente opzionali:

```sh
NVIM_ZOXIDE_BIN=/custom/bin/zoxide \
NVIM_SIOYEK_BIN=/custom/bin/sioyek \
nvim
```

Nel workflow TeX attuale, Sioyek viene usato da `vimtex` come viewer. `texlab` resta separato e non e' usato come entrypoint per preview o forward search.

### Core

- [`lua/myconf/core/editor/options.lua`](./lua/myconf/core/editor/options.lua): opzioni base, indentazione per filetype, wrapping per testo, scrolloff dinamico
- [`lua/myconf/core/mappings`](./lua/myconf/core/mappings): leader, shortcut base, split navigation, mapping terminali
- [`lua/myconf/core/cmd`](./lua/myconf/core/cmd): comandi custom come `:ConfigEdit`, `:ReloadConfig`, `:CodexHere`, `:Finder`, `:Z`
- [`lua/myconf/core/events`](./lua/myconf/core/events): autocmd generali e backdrop per alcune UI flottanti

### UI E Tema

- [`lua/myconf/plugins/colorscheme.lua`](./lua/myconf/plugins/colorscheme.lua): setup di `tokyonight` con palette custom
- [`lua/myconf/theme/palette.lua`](./lua/myconf/theme/palette.lua): converte la palette esterna in valori usati dal tema
- [`lua/myconf/ui/winbar.lua`](./lua/myconf/ui/winbar.lua): winbar custom con filename, icone e breadcrumb LSP via `nvim-navic`
- [`lua/myconf/plugins/lualine.lua`](./lua/myconf/plugins/lualine.lua): statusline

### Navigazione E Ricerca

- [`lua/myconf/plugins/telescope.lua`](./lua/myconf/plugins/telescope.lua): picker principali, `file_browser`, `zoxide`, `fzf`
- [`lua/myconf/plugins/fzf.lua`](./lua/myconf/plugins/fzf.lua): `fzf-lua` come alternativa rapida
- [`lua/myconf/plugins/nvim-tree.lua`](./lua/myconf/plugins/nvim-tree.lua): explorer laterale
- [`lua/myconf/plugins/smart-splits.lua`](./lua/myconf/plugins/smart-splits.lua): resize, swap buffer e integrazione con WezTerm

### Editing

- [`lua/myconf/plugins/treesitter.lua`](./lua/myconf/plugins/treesitter.lua): parser, highlighting, incremental selection
- [`lua/myconf/plugins/nvim-cmp.lua`](./lua/myconf/plugins/nvim-cmp.lua): completamento e snippet
- [`lua/myconf/plugins/conform.lua`](./lua/myconf/plugins/conform.lua): formatter per filetype
- [`lua/myconf/plugins/nvim-lint.lua`](./lua/myconf/plugins/nvim-lint.lua): linter su autocmd

### LSP

- [`lua/myconf/plugins/lsp/mason.lua`](./lua/myconf/plugins/lsp/mason.lua): installazione tool e language server
- [`lua/myconf/plugins/lsp/lspconfig.lua`](./lua/myconf/plugins/lsp/lspconfig.lua): enable dei server, override e keymap su `LspAttach`

## Come Funziona `lazy.nvim` In Questo Setup

Qui `lazy.nvim` fa tre cose:

1. bootstrap del plugin manager
2. import di tutte le plugin spec
3. lazy-loading vero e proprio tramite `event`, `ft`, `cmd` e `keys`

Scelte importanti del setup:

- `checker.enabled = true`: controlla aggiornamenti plugin
- `change_detection.notify = false`: niente spam di notifiche quando modifichi i file di config
- `lazy-lock.json`: blocca le versioni installate

Comandi utili:

- `:Lazy`: pannello principale
- `:Lazy sync`: installa/aggiorna e riallinea i plugin
- `:Lazy restore`: ripristina le versioni del lockfile

### Aggiungere Un Plugin

Per aggiungere un plugin nuovo:

1. crea un file in `lua/myconf/plugins/` oppure `lua/myconf/plugins/lsp/`
2. fai ritornare una spec `lazy.nvim`
3. preferisci sempre un trigger lazy (`event`, `ft`, `cmd`, `keys`) se il plugin non serve all'avvio
4. esegui `:Lazy sync`

Esempio minimale:

```lua
return {
   "folke/which-key.nvim",
   event = "VeryLazy",
   opts = {},
}
```

Se una modifica e' solo di runtime UI/tema puoi spesso usare `:ReloadConfig`; se tocchi plugin spec, dipendenze o bootstrap e' meglio fare `:Lazy sync` o riavviare Neovim.

## LSP, Mason, Formatter E Linter

### LSP

Questo setup separa installazione e attivazione:

- `Mason` installa server e tool
- `lspconfig` decide quali server abilitare davvero e con quali override

In [`lua/myconf/plugins/lsp/lspconfig.lua`](./lua/myconf/plugins/lsp/lspconfig.lua):

- i server vengono elencati in `servers`
- le eccezioni stanno in `server_overrides`
- tutti ricevono le capability di `cmp-nvim-lsp`
- le keymap LSP vengono registrate su `LspAttach`, quindi sono buffer-local

### Aggiungere Un Nuovo Language Server

Flusso consigliato:

1. aggiungi il package in `ensure_installed` di `mason-lspconfig` se vuoi auto-installarlo
2. aggiungi il nome del server nella lista `servers`
3. crea un override in `server_overrides` solo se servono `filetypes`, `cmd`, `settings` o `root_markers`

Esempio concettuale:

```lua
-- mason.lua
ensure_installed = {
   "ts_ls",
}

-- lspconfig.lua
local servers = {
   "ts_ls",
}

local server_overrides = {
   ts_ls = {
      settings = {
         -- ...
      },
   },
}
```

Nota importante: qui `mason_lspconfig.setup({ automatic_enable = false })` e' intenzionale. L'abilitazione reale dei server avviene in `lspconfig.lua`, non in `Mason`.

### Formatter

Il formatting e' gestito da `conform.nvim` in [`lua/myconf/plugins/conform.lua`](./lua/myconf/plugins/conform.lua).

Pattern del setup:

- mappa filetype -> formatter in `formatters_by_ft`
- eventuali formatter custom vengono definiti in `formatters`
- formatting manuale su `<leader>fi`
- `lsp_fallback = true` come fallback, non come prima scelta

Per aggiungere un formatter:

1. aggiungi il tool a `mason-tool-installer` se vuoi auto-installarlo
2. aggiungi la coppia filetype -> formatter in `formatters_by_ft`
3. se servono binario custom o argomenti custom, definiscilo in `formatters`

### Linter

Il linting e' gestito da `nvim-lint` in [`lua/myconf/plugins/nvim-lint.lua`](./lua/myconf/plugins/nvim-lint.lua).

Pattern del setup:

- mappa filetype -> linter in `linters_by_ft`
- `try_lint()` viene eseguito su `BufEnter`, `BufWritePost`, `InsertLeave`
- trigger manuale su `<leader>ll`

Per aggiungere un linter:

1. aggiungi il tool a `mason-tool-installer` se deve essere auto-installato
2. registra il filetype in `linters_by_ft`

## Comandi Utili Per Lavorare Sulla Config

- `:ConfigEdit`: apre un file della config con selettore
- `:ConfigVars`: apre `lua/configuration.lua`
- `:ReloadConfig`: ricarica tema e moduli leggeri
- `:Lazy`: pannello plugin
- `:Mason`: pannello tool/LSP

## Dipendenze Strettamente Necessarie

Questa sezione distingue tra:

- dipendenze che servono davvero per avviare e installare il setup base
- dipendenze introdotte dalla mia config custom
- dipendenze introdotte dai plugin attivi

### Hard Requirement Del Setup Base

| Dipendenza | Perche' serve |
| --- | --- |
| `nvim` 0.11+ | il setup usa API recenti come `vim.lsp.config()` / `vim.lsp.enable()` |
| `git` | bootstrap iniziale di `lazy.nvim` e installazione plugin |
| `make` | build di plugin nativi come `telescope-fzf-native` e `LuaSnip` |
| toolchain C/C++ (`clang` o `gcc`) | necessaria per build native e parser Treesitter |
| `~/.config/theme/colors.lua` | richiesto da `lua/myconf/theme/palette.lua`; senza questo file il tema non parte, anche se `tokyonight` viene installato automaticamente da `lazy.nvim` |

### Dipendenze Della Mia Config

Queste non arrivano da un plugin "generico": servono per comandi custom o per scelte esplicite di questa config.

| Dipendenza | Dove viene usata | Se la togli |
| --- | --- | --- |
| `zoxide` | `:Z` | il comando custom per saltare tra directory non funziona |
| `codex` | `:CodexHere*` | il comando fallisce con check su `executable("codex")` |
| `~/.config/latexindent/config.yaml` | formatter TeX in `conform.nvim` | il formatter TeX configurato non parte come previsto |
| `mypandoc` | `:PandocExport` | il comando custom di export non funziona |
| `code` | `:Code` | il comando che apre VS Code non funziona |
| `op` | `:Open` | il comando basato su 1Password CLI non funziona |
| `tmux` | mapping `<leader>lt` che apre `lazygit` in una nuova finestra | quel mapping specifico non funziona |

### Dipendenze Dei Plugin Attivi

Queste servono solo se vuoi mantenere le feature dei plugin gia' abilitate.

Nota:

- `fzf-lua` richiede il binario di sistema `fzf` nel `PATH`; `telescope-fzf-native` e' una cosa separata e copre solo l'estensione fuzzy di Telescope
- `tokyonight` non e' una dipendenza esterna da installare a mano; la dipendenza reale del tema resta `~/.config/theme/colors.lua`

| Dipendenza | Plugin / feature | Se la togli |
| --- | --- | --- |
| `fd` | `telescope.nvim` `find_files` | il picker file configurato con `fd` smette di funzionare correttamente |
| `rg` | `telescope.nvim` `live_grep` / `grep_string` | perdi la parte search basata su ripgrep |
| `fzf` | `ibhagwan/fzf-lua` (`<leader>zf`, `<leader>zs`, `<leader>zb`) | `fzf-lua` non parte |
| `zoxide` | `jvgrootveld/telescope-zoxide` | il picker zoxide di Telescope non funziona |
| `lazygit` | `kdheepak/lazygit.nvim` e mapping git | la UI git non si apre |
| `wezterm` | `mrjones2014/smart-splits.nvim` per i pane esterni | i mapping `<C-S-h/j/k/l>` verso pane WezTerm non funzionano |
| `latexmk` | `vimtex` e `texlab` | salta compilazione LaTeX e integrazione TeX corrente |
| `sioyek` | `vimtex` con `\\lv` | il workflow PDF LaTeX perde il viewer previsto |
| `node` | `copilot.lua`, `CopilotChat.nvim`, `prettier`, `eslint_d` | Copilot e parte del toolchain JS non partono |
| `python3` | wrapper Mason di `jdtls` | il server Java non si avvia |
| `java` / JDK 21+ | `jdtls` | il server Java non si avvia o fallisce il controllo versione |
| `latexindent` | `conform.nvim` per `tex` | perdi il formatter TeX configurato |

### Dipendenze Per-Platform Da Tenere D'Occhio

I riferimenti platform-specific non stanno piu' sparsi nei plugin: passano da `conf.external` in [`lua/configuration.lua`](./lua/configuration.lua), con fallback al `PATH` e, dove utile, ai path macOS piu' comuni.

| Dipendenza / path | Stato attuale | Impatto |
| --- | --- | --- |
| Sioyek app bundle macOS | fallback solo su macOS; su Linux e' preferito `sioyek` da `PATH` | viewer PDF LaTeX via `vimtex` |
| `open -R` | usato solo su macOS dentro `shell.reveal_path()` | su Linux c'e' fallback a `xdg-open`, su Windows a `explorer.exe` |
| `xdg-open` | richiesto solo su Linux per `:Finder` e reveal in `nvim-tree` | non serve su macOS o Windows |
| `explorer.exe` | richiesto solo su Windows per `:Finder` e reveal in `nvim-tree` | non serve su macOS o Linux |

### Nota Su Mason

`Mason` installa automaticamente una parte dei server e dei tool dichiarati nel repo, ma non va confuso con le dipendenze hard requirement del bootstrap.

In questo setup vengono richiesti automaticamente almeno:

- LSP: `html`, `cssls`, `svelte`, `lua_ls`, `graphql`, `emmet_ls`, `prismals`, `pyright`, `gopls`, `jdtls`, `texlab`
- tool: `prettier`, `stylua`, `isort`, `black`, `pylint`, `eslint_d`, `clang-format`, `latexindent`

Questi fanno parte del workflow editoriale che il repo si aspetta, ma non tutti sono indispensabili per "aprire Neovim". Alcuni richiedono anche runtime esterni reali:

- `jdtls` richiede `python3` e un `java` compatibile, nel tuo setup almeno Java 21
- `prettier` ed `eslint_d` richiedono `node`
- `latexindent` e' installato da Mason, ma questa config gli passa anche `~/.config/latexindent/config.yaml`

## Convenzioni Del Progetto

Se estendi questa config, conviene mantenere queste regole:

- un file plugin = una responsabilita' chiara
- toggle globali piccoli in `lua/configuration.lua`, non sparsi nei plugin
- moduli `core` senza side effect oscuri: meglio `setup()` espliciti
- usare lazy-loading per quasi tutto cio' che non serve al bootstrap
- evitare path assoluti di piattaforma se non strettamente necessari
- se aggiungi una feature con dipendenze esterne, documentala qui

## Bootstrap Rapido

Su una macchina nuova il percorso minimo e':

1. installare gli hard requirement della sezione sopra
2. posizionare questa config in `~/.config/nvim`
3. verificare che esista `~/.config/theme/colors.lua`
4. aprire `nvim`
5. eseguire `:Lazy sync`
6. aprire `:Mason` e verificare che server e tool necessari siano installati

## Cose Da Migliorare In Futuro

I punti tecnici piu' ovvi da ripulire sono:

- chiarire se `fzf-lua` deve rimanere come alternativa a Telescope o se va ridotto
- documentare eventuali dipendenze del file `~/.config/theme/colors.lua` se diventa condiviso tra piu' dotfiles
