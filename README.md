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
```

## Cloning Instructions

To clone the whole repository use the following command:

    git clone --recursive https://github.com/melissa-aguiar/Sandbox

or (if using ssh authentication keys)

    git clone --recursive git@github.com:melissa-aguiar/Sandbox.git

For older versions of Git (<1.6.5), use the following:

    git clone git://github.com/melissa-aguiar/Sandbox.git

or

    git clone git@github.com:melissa-aguiar/Sandbox.git

    git submodule init
    git submodule update

To update each submodule within this project use:

    git submodule foreach git rebase origin master

## Simulation Instructions

Go to a testbench directory. It must have a top manifest file:

    cd matmul/testbench

Run the following commands. You must have hdlmake command available
in your PATH environment variable.

Create the simualation makefile

    hdlmake

Compile the project

    make

Execute the simulation with GUI and aditional commands

    vsim -do run.do &

## Synthesis Instructions

Go to a syn directory. It must have a synthesis manifest file:

    cd matmul/syn

Run the following commands. You must have hdlmake command available
in your PATH environment variable.

    ./build_bitstream_local.sh
