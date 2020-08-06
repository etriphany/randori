#!/bin/bash

docker run --rm -ti --network host -v "$(dirname `pwd`)"/it:/home/randori/it docker.pkg.github.com/etriphany/randori/randori:1.1.0 $@