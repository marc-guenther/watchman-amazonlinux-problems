#!/bin/sh
image_name=watchman-test

time docker build -t "${image_name}" . && docker run -it --rm "${image_name}" "$@"
