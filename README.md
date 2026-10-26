# Dotfiles

⚡ This repo houses my main personal development setup with dotfiles for Neovim, Zsh, Git, and more.

It targets macOS on Apple Silicon and lives in the terminal, with ghostty, tmux and lazygit alongside the rest. Everything uses Catppuccin Mocha on a black background. Each tool's config sits in its own folder, and [GNU Stow](https://www.gnu.org/software/stow/) symlinks them into `$HOME`.

## Table of contents

- [What's inside](#whats-inside)
- [Requirements](#requirements)
- [Installation](#installation)
  - [Git identity](#git-identity)
- [Repo layout](#repo-layout)
- [Keybinds](#keybinds)
  - [ghostty](#ghostty)
  - [tmux](#tmux)
  - [zsh](#zsh)
  - [neovim](#neovim)
  - [lazygit](#lazygit)

## What's inside

| Tool       | Config                                             | Notes                                                |
| ---------- | -------------------------------------------------- | ---------------------------------------------------- |
| ghostty    | `ghostty/.config/ghostty/config`                   | Fira Code Nerd Font, Option acts as Alt              |
| zsh        | `zsh/.config/zsh/`, `zsh/.zshenv`, `zsh/.zprofile` | own plugin loader, fzf, zoxide, lazy nvm             |
| tmux       | `tmux/.config/tmux/tmux.conf`                      | Prefix `Ctrl-A`, vi copy mode                        |
| neovim     | `nvim/.config/nvim/`                               | Neovim 0.12 with `vim.pack`, LSP, fzf-lua, blink.cmp |
| lazygit    | `lazygit/.config/lazygit/config.yml`               | delta diffs, Catppuccin theme                        |
| lazydocker | `lazydocker/.config/lazydocker/config.yml`         |                                                      |
| git        | `git/.gitconfig`, `git/.config/git/`               | delta pager, ignore and attributes, hook templates   |

## Requirements

- macOS on Apple Silicon.
- An internet connection. Homebrew, packages, fonts and apps are all downloaded.
- An admin account. The Xcode and Homebrew steps ask for `sudo`.
- `git` to clone the repo. On a fresh Mac, running `git` prompts you to install the Xcode command line tools.
- Signed in to the App Store, so `mas` can install the App Store apps in `5_apps.sh`.

## Installation

Clone the repo into `~/Developer/random` (that's where the setup expects it), then run:

```sh
./setup.sh
```

It runs the scripts in `scripts/` in order. Steps that are already done get skipped, so it's safe to run again:

1. `1_xcode.sh` – Xcode command line tools
2. `2_homebrew.sh` – Homebrew
3. `3_packages.sh` – brew packages (neovim, tmux, fzf, fd, bat, eza, zoxide, git-delta, lazygit, nvm, stow, ...)
4. `4_fonts.sh` – fonts
5. `5_apps.sh` – apps (ghostty, rectangle, ...)
6. `6_projectsdir.sh` – creates `~/Developer` and `~/Developer/random`
7. `7_git_user.sh` – asks for your git name and email (see [Git identity](#git-identity))
8. `8_stow.sh` – stows `nvim zsh git lazygit tmux ghostty lazydocker`

> **Heads up:** `8_stow.sh` **deletes** your existing `~/.zprofile`, `~/.zshrc`, `~/.zshenv`, `~/.gitconfig`, `~/.hushlogin` and the matching folders in `~/.config` before linking. Back up anything you want to keep.

`zsh-plugin-load` is adapted from [zsh_unplugged](https://github.com/mattmc3/zsh_unplugged) by mattmc3 (Unlicense). See `zsh/.config/zsh/modules/plugins.zsh`.

For settings that only apply to one machine, use `~/.config/zsh/.workrc` and `~/.config/zsh/.personalrc`. Both are optional and git-ignored.

### Git identity

I keep my name and email out of the repo. `git/.gitconfig` has no `[user]` block. It ends with `[include] path = ~/.gitconfig-user`, and that file holds your name and email.

- `git/.gitconfig-user` is git-ignored and stowed to `~/.gitconfig-user`.
- `git/.gitconfig-user.example` is the committed template.
- `scripts/7_git_user.sh` creates `git/.gitconfig-user` (skipped if it exists). On an already set up machine, run it by hand, then `stow git`.
- Change the identity by editing `~/.gitconfig-user` or with `git config --file ~/.gitconfig-user user.email <email>`. `git config --global` writes to `~/.gitconfig`, but the include sits at the end of that file, so the included value still wins.

## Repo layout

```
setup.sh            runs scripts/1..8
scripts/            install steps
nvim/               ~/.config/nvim
zsh/                ~/.config/zsh, ~/.zshenv and ~/.zprofile (rc files plus modules/: node, completion, git, paths, plugins, spinner)
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
| `Option-X`             | Edit the current command line in nvim                    |
| `↑` / `↓`              | History search by what you have typed                    |
| `Home` / `End`         | Start / end of line                                      |
| `Ctrl-←` / `Ctrl-→`    | Previous / next word                                     |

Commands and behaviour:

| Command                              | Action                                                                                                                    |
| ------------------------------------ | ------------------------------------------------------------------------------------------------------------------------- |
| `cd <name>`                          | zoxide jump to the best match (a real path still works as plain `cd`)                                                     |
| `cdi`                                | Interactive zoxide picker                                                                                                 |
| `gclear`                             | Delete merged local branches except the current one, `develop`, `main` and `master`                                       |
| `zshtime`                            | Time an interactive shell start                                                                                           |
| `update-comp`                        | Rebuild the completion and fzf, zoxide, just init caches (`~/.cache/zsh`) and restart zsh. Run it after installing a tool |
| `zsh-plugin-load <owner/repo[@sha]>` | Clone a GitHub plugin, link its init file and source it. Used in `.zshrc`                                                 |
| `zsh-plugin-update`                  | `git pull` every cloned plugin, one by one, with a spinner (pinned skipped). Restart zsh afterwards                       |
| `zsh-plugin-outdated`                | List every plugin with current hash, date and status (up to date, outdated, pinned)                                       |
| `AUTO_CD`                            | Type a directory name to enter it, no `cd` needed                                                                         |
| `.nvmrc` / `.node-version`           | Checked on `cd` and at shell start. nvm loads only when a different Node version is needed                                |

Main aliases from `.aliasesrc`:

| Alias                                         | Command                                                        |
| --------------------------------------------- | -------------------------------------------------------------- |
| `ls`, `ll`, `lt`                              | eza (icons, groups first / long / tree)                        |
| `cat`, `catf`                                 | bat (with header and grid / plain)                             |
| `vi`, `vim`                                   | nvim                                                           |
| `lzg`, `lzd`                                  | lazygit, lazydocker                                            |
| `tx`, `txu`                                   | tmux, [tmxu](https://github.com/rogemus/tmxu)                  |
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
| `0` / `<leader>fr` | Recent files (current directory only)        |
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
| `Ctrl-s` (insert)           | Signature help                            |

**Diagnostics**

| Key         | Action                                    |
| ----------- | ----------------------------------------- |
| `]d` / `[d` | Next / previous diagnostic (nvim default) |
| `<leader>e` | Show the diagnostics for the current line |

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
