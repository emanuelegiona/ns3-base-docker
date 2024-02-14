#!/bin/bash

# MIT License

# Copyright (c) 2024 Emanuele Giona <giona.emanuele@gmail.com> (SENSES Lab, 
# Sapienza University of Rome)

# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:

# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.

# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

IMG_NAME=egiona/ns3-base

# Iterate on all supported configurations and (re)build images
for img_dir in */ ; do
    CURR_TAG="${img_dir%/}"

    echo ">>> Building image '${IMG_NAME}:${CURR_TAG}'..."
    cd "${CURR_TAG}" && \ 
    docker buildx build -t "${IMG_NAME}:${CURR_TAG}" . && \ 
    docker push "${IMG_NAME}:${CURR_TAG}" && \ 
    docker image rm "${IMG_NAME}:${CURR_TAG}" && \ 
    cd ..
done
