# syntax=docker/dockerfile:1

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

FROM ubuntu:22.04

LABEL maintainer="giona.emanuele@gmail.com"
LABEL version="0.1"
LABEL description="Ubuntu 22.04 with ns-3.41"

ARG NS_ALLINONE="ns-allinone-3.41"
ARG NS_VER="ns-3.41"

ARG TMP_DOWNLOAD_DIR="/home/downloads"

# ===== Evinronment variables available in containers too =====
# Separate directories simplify CMake build between profiles
ENV NS3_DEBUG_DIR="/home/ns3-debug"
ENV NS3_OPTIMIZED_DIR="/home/ns3-optimized"

# Variable pointing at ns-3 dedicated Python 3 environment
ENV NS3_PY_ENV="/home/ns3-pyenv"

# ===== Basic OS updates and ns-3 requirements =====
ARG DEBIAN_FRONTEND=noninteractive
RUN apt -y update && apt -y upgrade && \
 apt -y install make wget build-essential g++ python3 virtualenv apt-utils && \
 apt -y install qtbase5-dev qtchooser qt5-qmake qtbase5-dev-tools && \
 apt -y install gir1.2-goocanvas-2.0 python3-gi python3-gi-cairo python3-pygraphviz gir1.2-gtk-3.0 ipython3 && \
 apt -y install autoconf cvs bzr unrar && \
 apt -y install gdb valgrind && \
 apt -y install uncrustify && \
 apt -y install doxygen graphviz imagemagick && \
 apt -y install texlive texlive-extra-utils texlive-latex-extra texlive-font-utils dvipng latexmk && \
 apt -y install python3-sphinx dia && \
 apt -y install gsl-bin libgsl-dev libgslcblas0 && \
 apt -y install tcpdump && \
 apt -y install sqlite sqlite3 libsqlite3-dev && \
 apt -y install libxml2 libxml2-dev && \
 apt -y install cmake libc6-dev libc6-dev-i386 automake python3-pip && \
 pip3 install cxxfilt && \
 apt -y install libgtk-3-dev && \
 apt -y install vtun lxc uml-utilities libboost-all-dev && \
 apt -y install gfortran unzip && \
# ===== Downloading: ns-3 source; Creating: Python 3 environment for ns-3 =====
 cd /home && mkdir "$TMP_DOWNLOAD_DIR" && cd "$TMP_DOWNLOAD_DIR" && \
 wget "https://www.nsnam.org/releases/$NS_ALLINONE.tar.bz2" && \
 tar xjf "$NS_ALLINONE.tar.bz2" && \
 cp -R "$NS_ALLINONE/" ../ && mv ../"$NS_ALLINONE" "$NS3_DEBUG_DIR" && \
 cp -R "$NS_ALLINONE/" ../ && mv ../"$NS_ALLINONE" "$NS3_OPTIMIZED_DIR" && \
 # Python virtual environment for ns-3
 virtualenv --python=/usr/bin/python3 "$NS3_PY_ENV"

# ===== Building: ns-3; Cleanup: temporary downloads directory =====
ENV NS3_DEBUG_DIR="$NS3_DEBUG_DIR/$NS_VER"
ENV NS3_OPTIMIZED_DIR="$NS3_OPTIMIZED_DIR/$NS_VER"
ENV CXX_CONFIG="-Wall -Werror -Wno-unused-variable"

COPY ns3-build/* ns3-utils/* /home/
RUN cd /home && \
 # Build: debug
 chmod +x build-debug.sh && ./build-debug.sh && \
 # Build: optimized
 chmod +x build-optimized.sh && ./build-optimized.sh && \
 # Utility for switching between profiles
 echo "" >> ~/.bashrc && \
 echo "# Automatic .bashrc reload and NS3 profile variable" >> ~/.bashrc && \
 echo "trap '. ~/.bashrc' USR1" >> ~/.bashrc && \
 echo 'export NS3_CURR_PROFILE=${NS3_DEBUG_DIR}' >> ~/.bashrc && \
 # Cleanup
 rm -rf "$TMP_DOWNLOAD_DIR" && ./build-debug.sh

CMD ["/bin/bash"]
