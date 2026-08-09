# LightVim

[![Neovim 0.12+](https://img.shields.io/badge/Neovim-0.12%2B-57A143?style=flat-square&logo=neovim&logoColor=white)](https://github.com/neovim/neovim/releases/tag/v0.12.0)
[![GitHub Stars](https://img.shields.io/github/stars/mosheavni/lightvim?style=flat-square&logo=github&color=f0c040)](https://github.com/mosheavni/lightvim/stargazers)
[![Last Commit](https://img.shields.io/github/last-commit/mosheavni/lightvim?style=flat-square&logo=git&color=blue)](https://github.com/mosheavni/lightvim/commits/master)
[![License](https://img.shields.io/github/license/mosheavni/lightvim?style=flat-square&color=green)](https://github.com/mosheavni/lightvim/blob/master/LICENSE)

LightVim is a Neovim config.

## Requirements

- Neovim **v0.12+** (minimum — uses `vim.pack` for plugin management)

### External CLIs

Only install what's relevant to you.

#### LSP servers

| CLI                           | Language                |
| ----------------------------- | ----------------------- |
| `typescript-language-server`  | TypeScript / JavaScript |
| `pyright-langserver`          | Python                  |
| `bash-language-server`        | Bash / Shell            |
| `vscode-html-language-server` | HTML                    |
| `vscode-css-language-server`  | CSS / SCSS / Less       |
| `terraform-ls`                | Terraform               |
| `docker-langserver`           | Dockerfile              |
| `vscode-json-languageserver`  | JSON                    |
| `yaml-language-server`        | YAML                    |
| `lua-language-server`         | Lua                     |
| `marksman`                    | Markdown                |

#### Formatters

> [!NOTE]
> (used as `formatprg` fallback when LSP has no formatter)

| CLI          | Language                                                                         |
| ------------ | -------------------------------------------------------------------------------- |
| `prettierd`  | JS / TS / HTML / CSS / JSON / YAML / GraphQL / Vue / Svelte / Astro / Handlebars |
| `ruff`       | Python                                                                           |
| `shfmt`      | Shell / Zsh                                                                      |
| `terraform`  | Terraform                                                                        |
| `terragrunt` | HCL                                                                              |
| `tombi`      | TOML                                                                             |

## How to use

Just clone it to `~/.config/lightvim` and use with `NVIM_APPNAME` environment variable.

```sh
# 1. clone it
git clone https://github.com/mosheavni/lightvim.git ~/.config/lightvim

# 2. use it with NVIM_APPNAME
NVIM_APPNAME=lightvim nvim
```

Plugins are managed with the builtin `vim.pack`. Run `:packupdate` to update all plugins and `:packdel` to remove ones no longer declared in the config.

## TODOs

- [x] Add mini pick
- [x] Add Treesitter
- [x] verify completions
