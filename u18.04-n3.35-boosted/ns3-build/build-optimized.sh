#!/bin/bash

# MIT License

# Copyright (c) 2025 Emanuele Giona <giona.emanuele@gmail.com> (SENSES Lab, 
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

NS3_DIR=${NS3_OPTIMIZED_DIR}

echo "Switching to optimized profile in ns-3..."

cd $NS3_DIR

NS3_CONFIG="--build-profile=optimized --out=build --enable-examples --enable-tests"

# Ensure ns-3 is building against the newer Boost C++ libraries installed
NS3_CONFIG="${NS3_CONFIG} --boost-includes=${NEW_BOOST_INCLUDES} --boost-libs=${NEW_BOOST_LIBS}"

CXX_CONFIG="-Wall"

. ${NS3_PY_ENV}/bin/activate

OUTCOME=1
CXXFLAGS="${CXX_CONFIG}" ./waf configure $NS3_CONFIG && OUTCOME=0

if [[ "$OUTCOME" -eq 1 ]]; then
    echo "Error: configuration failed"
    exit 1
fi

OUTCOME=1
./waf build && OUTCOME=0

if [[ "$OUTCOME" -eq 1 ]]; then
    echo "Error: build failed"
    exit 1
fi

./waf --check-profile
deactivate

sed -i 's/^\(export NS3_CURR_PROFILE=\).*$/\1${NS3_OPTIMIZED_DIR}/' ~/.bashrc && \
cd /home && \
kill -USR1 $PPID

exit 0
