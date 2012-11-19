opal-home
=========

Opal home for developpers: control your execution environnement outside of opal server code.

## Set-up

1. Edit Makefile and set env variables
2. make all
3. make conf
4. Edit conf/opal-config.properties

## Start Opal

1. Ensure set-up was done (compilation and configuration).
2. make launch

## Update a sub-project

For instance, a change was made in opal-core-ws:

1. make opal p=opal-core-ws
2. make launch

If magma is also in development:

1. make magma p=datasource-csv
2. make launch

## Other Makefile targets

See Makefile for more details.

make log
make update
make magma-update
