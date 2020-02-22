# karkinos

This repository contains the scripting/automation for our BIOL-650 group project
(Spring 2020 semester at RIT).  The project is based on the data from  [this
paper](https://www.sciencedirect.com/science/article/pii/S2352340918302920).

## Getting Started

To use this repository, clone it down somewhere and create a `data` directory
inside it.  If you want the data to live outside of the repository (e.g. on
a larger disk mounted elsewhere, or in a team folder), you can use a symlink.
For example:

    $ mkdir /some/big/disk/karkinos-data

    $ git clone git@github.com:sjl/karkinos
    …

    $ cd karkinos

    $ ln -s /some/big/disk/karkinos-data data

Scripts to perform each step of the pipeline are in `src`, and are prefixed with
their stage number for ease of sorting.  When run, a stage script assumes all
previous scripts have been run, and will create a corresponding directory in
`data` with the stage number and a similar name.  For example:

    $ ./src/00-get-input.sh
    Retrieving files...

    $ tree -L 1 data
    data
    └── 00-raw
        ├── SRR6671104.1
        ├── SRR6671105.1
        ├── …
        └── SRR6671116.1

    $ ./src/01-dump-fastqs.sh
    Dumping FASTQs from input files (using 2 cores)...

    $ tree -L 1 data
    data
    ├── 00-raw
    │   ├── SRR6671104.1
    │   ├── SRR6671105.1
    │   ├── …
    │   └── SRR6671116.1
    └── 01-input-fastqs
        ├── C0_1.fastq
        ├── C0_2.fastq
        ├── …
        └── C8_2.fastq

All stage scripts assume you are running them from within the root of the
repository.  This is not checked (TODO: check this).

Some stages can parallelize their computation.  The environment variable `CORES`
will be used if defined.  If undefined, `2` cores will be used.

## Requirements

The following commands need to be in your `PATH` — feel free to install them
however you like:

* `fasterq-dump`
* `fastqc`
