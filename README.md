# Sandbox


![Latest tag](https://img.shields.io/github/tag/lnls-dig/fofb-ctrl-gw.svg?style=flat)
[![Latest release](https://img.shields.io/github/release/lnls-dig/fofb-ctrl-gw.svg?style=flat)](https://github.com/lnls-dig/fofb-ctrl-gw/releases)
[![LGPL License 3.0](https://img.shields.io/github/license/lnls-dig/fofb-ctrl-gw.svg?style=flat)](COPYING)

Matrix multiplication core for the Fast Orbit Feedback Controller

## Project Folder Organization

```
*
|
|-- matmul:
|    |   HDL (VHDL) matrix multiplication core for the FOFB Controller.
|    |
|    |-- modules:
|    |        Modules specific to matrix multiplication core.
|    |
|    |-- sim:
|    |        Generic simulation files.
|    |
|    |-- syn:
|    |        Synthesis specific files (user constraints files and top design
|    |          specification).
|    |
|    |-- testbench:
|    |        Testbenches for modules and top level designs. May use modules
|    |          defined elsewhere (specific within the 'sim" directory).
|    |
|    |-- top:
|    |        Top design modules.
|
*
