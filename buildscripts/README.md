# Build Scripts for `size`

This folder contains a bash script ([buildAll.sh](buildAll.sh)) to build `size` for release:

## Prerequisites

Both scripts require Go to run. If you don't have Go installed on your system, you can find installation instructions
at [https://golang.org/doc/install](https://golang.org/doc/install)

The shell script requires Gum to run. If you don't have Gum installed on your system, you can find installation
instructions
at [https://github.com/charmbracelet/gum?tab=readme-ov-file#installxation](https://github.com/charmbracelet/gum?tab=readme-ov-file#installation)

All builds will be placed in the `out` directory. You may need to run `chmod +x` on the executables for UNIX-like
systems to make them executable.