# Dotfiles

macOS (Apple Silicon) setup for web development, centred on the terminal: **ghostty + zsh + tmux + neovim + lazygit**. Everything uses the Catppuccin Mocha palette on a black background. Packages are symlinked into `$HOME` with [GNU Stow](https://www.gnu.org/software/stow/).

| Tool       | Config                                     | Notes                                                |
| ---------- | ------------------------------------------ | ---------------------------------------------------- |
| ghostty    | `ghostty/.config/ghostty/config`           | Fira Code Nerd Font, Option acts as Alt              |
| zsh        | `zsh/.config/zsh/`, `zsh/.zprofile`        | zsh_unplugged plugins, fzf, zoxide, lazy nvm         |
| tmux       | `tmux/.config/tmux/tmux.conf`              | Prefix `Ctrl-A`, vi copy mode                        |
| neovim     | `nvim/.config/nvim/`                       | Neovim 0.12 with `vim.pack`, LSP, fzf-lua, blink.cmp |
| lazygit    | `lazygit/.config/lazygit/config.yml`       | delta diffs, Catppuccin theme                        |
| lazydocker | `lazydocker/.config/lazydocker/config.yml` |                                                      |
| git        | `git/.gitconfig`, `git/.config/git/`       | delta pager, ignore and attributes, hook templates   |

## Installation

Clone the repository (the setup expects projects under `~/Developer/random`), then run:

```sh
./setup.sh
```

It runs the scripts in `scripts/` in order and skips steps that are already done:

1. `1_xcode.sh` – Xcode command line tools
2. `2_homebrew.sh` – Homebrew
3. `3_packages.sh` – brew packages (neovim, tmux, fzf, fd, bat, eza, zoxide, git-delta, lazygit, nvm, stow, ...)
4. `4_fonts.sh` – fonts
5. `5_apps.sh` – apps (ghostty, rectangle, ...)
6. `6_projectsdir.sh` – creates `~/Developer` and `~/Developer/random`
7. `7_stow.sh` – stows `nvim zsh git lazygit tmux ghostty lazydocker`

> `7_stow.sh` **deletes** the existing `~/.zprofile`, `~/.zshrc`, `~/.zshenv`, `~/.gitconfig`, `~/.hushlogin` and the matching folders in `~/.config` before linking. Back up anything you want to keep.

Machine-specific zsh settings go in `~/.config/zsh/.workrc` and `~/.config/zsh/.personalrc`. Both are optional and git-ignored.

## Layout

```
setup.sh            runs scripts/1..7
scripts/            install steps
nvim/               ~/.config/nvim
zsh/                ~/.config/zsh and ~/.zprofile
tmux/               ~/.config/tmux
ghostty/            ~/.config/ghostty
lazygit/            ~/.config/lazygit
lazydocker/         ~/.config/lazydocker
git/                ~/.gitconfig and ~/.config/git
tmxu/               session templates for the tmxu tool
```

Config files are split into sections with `# ─── Section ───` (`-- ─── Section ───` in Lua) headers, in the style of `tmux.conf`.

## Keybinds

### ghostty

| Key            | Action                                                            |
| -------------- | ----------------------------------------------------------------- |
| `Ctrl-Tab`     | Sends the sequence tmux binds to its session switcher             |
| `Option-<key>` | Sent as `Alt-<key>` (`macos-option-as-alt`), used by tmux and zsh |

### tmux

Prefix is `Ctrl-A`. Press it first, release, then the key. `Ctrl-A Ctrl-A` sends a literal `Ctrl-A`.

| Key                      | Action                                                   |
| ------------------------ | -------------------------------------------------------- |
| `prefix r`               | Reload the config                                        |
| `prefix \|` / `prefix -` | Split horizontally / vertically (keeps the directory)    |
| `prefix c`               | New window (keeps the directory)                         |
| `prefix .`               | Rename the pane                                          |
| `prefix g`               | Lazygit in a popup, `q` closes it                        |
| `Alt-←/→/↑/↓`            | Move between panes                                       |
| `Alt-t`                  | New window (keeps the directory)                         |
| `Alt-1` … `Alt-9`        | Select window 1–9                                        |
| `Ctrl-Tab`               | Fuzzy session switcher (needs the ghostty keybind above) |

Copy mode uses vi keys:

| Key        | Action                               |
| ---------- | ------------------------------------ |
| `v`        | Start selection                      |
| `Ctrl-v`   | Toggle block selection               |
| `y`        | Copy to the macOS clipboard and exit |
| Mouse drag | Copy to the macOS clipboard          |

Windows and panes start at 1. `focus-events` is on so nvim reloads files changed elsewhere.

### zsh

| Key                    | Action                                                   |
| ---------------------- | -------------------------------------------------------- |
| `Ctrl-R` or `Option-R` | fzf history search                                       |
| `Option-F`             | fzf file picker (bat preview), pastes the path           |
| `Option-D`             | fzf directory picker (eza tree preview), changes into it |
| `↑` / `↓`              | History search by what you have typed                    |
| `Home` / `End`         | Start / end of line                                      |
| `Ctrl-←` / `Ctrl-→`    | Previous / next word                                     |

Commands and behaviour:

| Command                    | Action                                                                                           |
| -------------------------- | ------------------------------------------------------------------------------------------------ |
| `cd <name>`                | zoxide jump to the best match (a real path still works as plain `cd`)                            |
| `cdi`                      | Interactive zoxide picker                                                                        |
| `gclear`                   | Delete merged local branches except the current one, `develop`, `main` and `master`              |
| `zshtime`                  | Time an interactive shell start                                                                  |
| `AUTO_CD`, `AUTO_PUSHD`    | Type a directory name to enter it. `dirs -v` lists the directory stack, `cd ~2` jumps to entry 2 |
| `.nvmrc` / `.node-version` | Checked on `cd` and at shell start. nvm loads only when a different Node version is needed       |

Main aliases from `.aliasesrc`:

| Alias                                         | Command                                                        |
| --------------------------------------------- | -------------------------------------------------------------- |
| `ls`, `ll`, `lt`                              | eza (icons, groups first / long / tree)                        |
| `cat`, `catf`                                 | bat (with header and grid / plain)                             |
| `vi`, `vim`                                   | nvim                                                           |
| `lzg`, `lzd`                                  | lazygit, lazydocker                                            |
| `tx`, `txu`                                   | tmux, tmxu                                                     |
| `g`, `gs`, `gd`, `gl`, `gf`, `gp`, `gP`, `gm` | git, status, diff, log, fetch, pull, push, merge               |
| `gc`, `gC`, `gA`, `gb`, `greset`              | commit -am, checkout, add ., fzf branch checkout, reset --hard |
| `fzfp`, `fzfv`                                | fzf with preview, fzf opening the file in nvim                 |
| `ai`                                          | claude                                                         |

### neovim

Leader is `Space`.

**Find (fzf-lua)**

| Key                | Action                                       |
| ------------------ | -------------------------------------------- |
| `-`                | Find file                                    |
| `=`                | Open buffers                                 |
| `0` / `<leader>fr` | Recent files                                 |
| `<leader>fs`       | Grep in files                                |
| `<leader>/`        | Grep in the current file                     |
| `<leader>ft`       | Toggle ignoring test files in the pickers    |
| `<leader>gs`       | Git status                                   |
| `<leader>m`        | Marks                                        |
| `<leader>td`       | List TODO, HACK, PERF, NOTE and FIX comments |

**Buffers and tabs**

| Key                       | Action                                      |
| ------------------------- | ------------------------------------------- |
| `L`                       | Last seen buffer                            |
| `<leader>]` / `<leader>[` | Next / previous buffer                      |
| `<leader>}` / `<leader>{` | Last / first buffer                         |
| `<leader>bD`              | Wipe buffers that are not shown in a window |
| `<leader>R`               | Reload the file after an external change    |
| `]t` / `[t`               | Next / previous tab                         |
| `]T` / `[T`               | Last / first tab                            |

**Windows and editing**

| Key                  | Action                                |
| -------------------- | ------------------------------------- |
| `Ctrl-h/j/k/l`       | Move between windows                  |
| `J` / `K` (visual)   | Move the selected lines down / up     |
| `<leader>y` (visual) | Copy to the system clipboard          |
| `n` / `N`            | Next / previous match, cursor centred |
| `Esc`                | Clear the search highlight            |
| `<leader>F`          | Format the file or selection          |

**LSP**

| Key                         | Action                                    |
| --------------------------- | ----------------------------------------- |
| `gd` / `gD` / `gI`          | Definition / declaration / implementation |
| `<leader>gr`                | References                                |
| `<leader>D`                 | Type definition                           |
| `<leader>ds` / `<leader>ws` | Document / workspace symbols              |
| `<leader>rn`                | Rename                                    |
| `<leader>ca`                | Code action                               |
| `K`                         | Hover documentation                       |

**Jump (flash)**

| Key                             | Action                     |
| ------------------------------- | -------------------------- |
| `s`                             | Jump to a label            |
| `S`                             | Select a treesitter node   |
| `r` (operator pending)          | Remote flash               |
| `tr` (operator pending, visual) | Treesitter search          |
| `Ctrl-s` (command line)         | Toggle flash in `/` search |

**File explorer (neo-tree)**

| Key                   | Action                                                   |
| --------------------- | -------------------------------------------------------- |
| `\`                   | Open the explorer as a float, revealing the current file |
| `\` (in the explorer) | Close it                                                 |
| `Space`               | Expand or collapse a node                                |
| `P`                   | Toggle preview                                           |
| `O`                   | Open in Finder                                           |
| `U`                   | Focus the parent directory                               |

**Completion (blink.cmp)**

| Key                 | Action               |
| ------------------- | -------------------- |
| `Enter`             | Accept               |
| `Tab` / `Shift-Tab` | Next / previous item |

**Per filetype (`ftplugin/`)**

| Key          | Filetypes                   | Action                                                    |
| ------------ | --------------------------- | --------------------------------------------------------- |
| `<leader>lo` | go                          | Add a debug `print` line for the word under the cursor    |
| `<leader>lo` | typescript, typescriptreact | Add a `console.log` line for the word under the cursor    |
| `<leader>di` | typescript, typescriptreact | Add a `console.dir` line for the word under the cursor    |
| `<leader>js` | go                          | Add a `json:"snake_case"` tag to the current struct field |

**Commands**

| Command           | Action                                         |
| ----------------- | ---------------------------------------------- |
| `:FormatToggle`   | Turn format on save on or off (off by default) |
| `:WipeBuffers`    | Wipe buffers that are not shown in a window    |
| `:FzfToggleTests` | Toggle ignoring test files in the pickers      |

Files are saved automatically on `InsertLeave` and `TextChanged`.

### lazygit

| Key               | Action                                                      |
| ----------------- | ----------------------------------------------------------- |
| `E` (files panel) | Commit with a message prompt and a Claude co-author trailer |
| `q`               | Quit without confirmation                                   |
| `?`               | Show every built-in keybind                                 |

Diffs are rendered with delta.
