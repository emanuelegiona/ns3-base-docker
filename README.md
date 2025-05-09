# ns-3 base Docker images

[ns-3][ns3] installations using [Docker][docker].

The scope of this repository is to automate the installation process of 
ns-3 in order to provide a hassle-free setup process for a 
simulation environment.

Images ship with ns-3 installations, provided pre-built in `debug` and `optimized` profiles, with the *former* being the active version on a first run; utility scripts to quickly switch between them are provided (see below).

## Available configurations *(latest first)*

Docker image name: [**`egiona/ns3-base`**][docker-hub-repo].

| Docker image tag | OS | ns-3 | Build system | Dockerfile |
| :---: | :---: | :---: | :---: | :---: |
| [`u22.04-n3.41`][image6] | Ubuntu 22.04 | [3.41][ns3.41] | CMake | [link][file6] |
| [`u22.04-n3.40`][image5] | Ubuntu 22.04 | [3.40][ns3.40] | CMake | [link][file5] |
| [`u20.04-n3.40`][image4] | Ubuntu 20.04 | [3.40][ns3.40] | CMake | [link][file4] |
| [`u18.04-n3.35-boosted`][image3b] | Ubuntu 18.04</br>with Boost C++ v1.74 | [3.35][ns3.35] | Waf | [link][file3b] |
| [`u18.04-n3.35`][image3] | Ubuntu 18.04 | [3.35][ns3.35] | Waf | [link][file3] |
| [`u18.04-n3.34-boosted`][image2b] | Ubuntu 18.04</br>with Boost C++ v1.74 | [3.34][ns3.34] | Waf | [link][file2b] |
| [`u18.04-n3.34`][image2] | Ubuntu 18.04 | [3.34][ns3.34] | Waf | [link][file2] |
| [`u18.04-n3.33-boosted`][image1b] | Ubuntu 18.04</br>with Boost C++ v1.74 | [3.33][ns3.33] | Waf | [link][file1b] |
| [`u18.04-n3.33`][image1] | Ubuntu 18.04 | [3.33][ns3.33] | Waf | [link][file1] |

Full changelog can be found at [this page](./CHANGELOG.md).

<!-- > New revisions of images (_i.e. `-rN` suffix_) **do not overwrite** previous ones in order to provide backwards compatibility.
Previous tags can still be found on [DockerHub][docker-hub-repo], but their use is discouraged. -->

<!-- ### Discontinued images

The following image tags have been discontinued and are not available from the DockerHub repository.

If you are using any of these tags, please consider switching to a different one that is still supported.

| Docker image tag | Reason | Date |
| :---: | :---: | :---: |
| `u20.04-n3.37-w1.12.5` <br> `u18.04-n3.37-w1.12.4-r2` <br> `u18.04-n3.37-w1.12.4` | GCC compiler issues; <br> not solved by Ubuntu 20.04 upgrade | 2023/10/11 | -->

### Contributing

Any problems should be reported via the GitHub issue tracker.

Users are welcomed to contribute new images (_e.g._ different base image or other ns-3 versions) via Pull Request and adhering to the following style:

- Directory named `<A-B>` with: `A` equal to an arbitrary versioned base image short-hand (_i.e._ `u20.04` refers to Ubuntu 20.04); and `B` equal to the ns-3 version bundled (_i.e._ `n3.40` refers to ns-3.40).

    Such directory name will also be used as image tag.

- The directory shall contain a well-commented `Dockerfile` for the image creation.

    Other contents may be freely modified, although for uniformity purposes it is advised to maintain the same functionality they provide.
    The `ns3-build` directory contains useful scripts to swap between ns-3 builds and development utilities; if modified, you should take care of solving this task.

# Usage guidelines

## Core instructions

> The following instructions should apply to all platforms supported by Docker. 
However, _utility scripts_ are only provided for UNIX-like systems.

1. Install Docker (please refer to [official guidelines][docker-install] w.r.t. your own OS)

2. Select your desired Docker image according to the table above using

    `docker pull egiona/ns3-base:<tag>`

    _Please refer to the table above for latest available tags._ <br>
    _Usage of old tags found on [DockerHub][docker-hub-repo] is generally discouraged, unless you have a reason to do it._

3. Retrieve the desired image identifier using 

    `docker images`

4. Launch a container using the selected image using 

    `docker run -td --name <container name> <image ID>`

5. Launch a live terminal from the container using 

    `docker exec -it <container ID or name> /bin/bash`

    _You can obtain a running container's ID using_&nbsp; `docker ps` _, or_&nbsp; `docker container ls -a` _(the latter also includes containers in any state)._

## Utility scripts

1. You can switch between `debug` and `optimized` builds of ns-3 (see [details][ns3-builds]) using 

    [`./build-debug.sh`][latest-debug] or [`./build-optimized.sh`][latest-optimized] respectively.

    The aforementioned utility scripts are placed in the directory `/home` of a container's filesystem.

2. A utility script in the form of a [Makefile][latest-makefile] is provided.

    Similarly to [build scripts][latest-build], this utility Makefile is placed in the directory `/home` of a container's filesystem.

    This script allows for easy decoupling of development directory from ns-3's source directory.
    Indeed, it is possible to keep novel modules and program driver scripts outside `src` (or `contrib`) and `scratch` directories of the ns-3 installation directory during development, and only copying them afterwards.
    This is especially useful when paired with mounted directories.

    Multiple targets are present, allowing: ns-3 current version checking, compilation and execution of simulation driver programs (copying them to `scratch` subdir first), management of ns-3 modules (creation in `contrib` subdir and copy outside, synchronization of contents, elimination), and debugging (GNU debugger, Valgrind, ns-3 tests).

    Use the following command for all details:

    `make help`

## Optional instructions

> As long as you `docker restart` the same container, any modification to its contents will be preserved.
However, it is advisable to keep a _local backup copy_ of your modules and experiment results.

1. Copy an arbitrary local file into the container's filesystem using

    `docker cp <path/to/file> <container ID>:<desired/path/to/file>`

2. Copy an arbitrary container's file to local filesystem using

    `docker cp <container ID>:<path/to/file> <local/path/to/file>`

3. Mount a local directory into a container (just once, instead of `docker run`) using

    `docker run -td --mount type=bind,source=<local/FS/path>,target=<container/FS/path> --name <container name> <image ID>`

    _Paths to be mounted must be absolute._

    _This is only needed the **first time** a container is instantiated, subsequent calls to_&nbsp; `docker start` _on the same container will automatically load the mounted directory._

    _**Warning:** existing container contents at the same target path will be overwritten with the ones provided by the local filesystem._

4. An environment variable `CXX_CONFIG` is available for user-defined scripts to adapt their GCC compilation parameters; by default, such variable holds the following contents:

    `CXX_CONFIG="-Wall -Werror -Wno-unused-variable"`

    Moreover, [build scripts][latest-build] provide an exit value reflective of ns-3's configuration and build outcome: this might be leveraged in CD/CI pipelines.

# Citing this work

If you use any of the Docker images described in this repository, please cite this work using any of the following methods:

**APA**
```
Giona, E. ns-3 Docker images [Computer software]. https://doi.org/10.5281/zenodo.10657287
```

**BibTeX**
```
@software{Giona_ns-3_Docker_images,
author = {Giona, Emanuele},
doi = {10.5281/zenodo.10657287},
license = {MIT},
title = {{ns-3 Docker images}},
url = {https://github.com/emanuelegiona/ns3-base-docker}
}
```

Bibliography entries generated using [Citation File Format][cff] described in the [CITATION.cff][citation] file.

# License

**Copyright (c) 2024 Emanuele Giona ([SENSES Lab][senseslab], Sapienza University of Rome)**

This repository and Docker images themselves are distributed under [MIT license][docker-license].

However, ns-3 is distributed under its [own license][ns3-license].
All installed packages may also be subject to their own license, and the license chosen for the Docker images does not necessarily apply to them.

**Diclaimer: Docker, Ubuntu, ns-3, Boost, and other cited or included software belongs to their respective owners.**



[ns3]: https://www.nsnam.org/
[docker]: https://www.docker.com/

[docker-hub-repo]: https://hub.docker.com/r/egiona/ns3-base

[ns3.33]: https://www.nsnam.org/releases/ns-3-33/
[ns3.34]: https://www.nsnam.org/releases/ns-3-34/
[ns3.35]: https://www.nsnam.org/releases/ns-3-35/
[ns3.40]: https://www.nsnam.org/releases/ns-3-40/
[ns3.41]: https://www.nsnam.org/releases/ns-3-41/

[latest-debug]: ./u22.04-n3.41/ns3-build/build-debug.sh
[latest-optimized]: ./u22.04-n3.41/ns3-build/build-optimized.sh
[latest-build]: ./u22.04-n3.41/ns3-build/
[latest-makefile]: ./u22.04-n3.41/ns3-utils/Makefile

[image6]: https://hub.docker.com/r/egiona/ns3-base/tags?page=1&name=u22.04-n3.41
[image5]: https://hub.docker.com/r/egiona/ns3-base/tags?page=1&name=u22.04-n3.40
[image4]: https://hub.docker.com/r/egiona/ns3-base/tags?page=1&name=u20.04-n3.40
[image3b]: https://hub.docker.com/r/egiona/ns3-base/tags?page=1&name=u18.04-n3.35-boosted
[image3]: https://hub.docker.com/r/egiona/ns3-base/tags?page=1&name=u18.04-n3.35
[image2b]: https://hub.docker.com/r/egiona/ns3-base/tags?page=1&name=u18.04-n3.34-boosted
[image2]: https://hub.docker.com/r/egiona/ns3-base/tags?page=1&name=u18.04-n3.34
[image1b]: https://hub.docker.com/r/egiona/ns3-base/tags?page=1&name=u18.04-n3.33-boosted
[image1]: https://hub.docker.com/r/egiona/ns3-base/tags?page=1&name=u18.04-n3.33
[file6]: ./u22.04-n3.41/Dockerfile
[file5]: ./u22.04-n3.40/Dockerfile
[file4]: ./u20.04-n3.40/Dockerfile
[file3b]: ./u18.04-n3.35-boosted/Dockerfile
[file3]: ./u18.04-n3.35/Dockerfile
[file2b]: ./u18.04-n3.34-boosted/Dockerfile
[file2]: ./u18.04-n3.34/Dockerfile
[file1b]: ./u18.04-n3.33-boosted/Dockerfile
[file1]: ./u18.04-n3.33/Dockerfile

[docker-install]: https://docs.docker.com/engine/install/

[ns3-builds]: https://www.nsnam.org/docs/release/3.40/tutorial/html/getting-started.html#build-profiles

[cff]: https://citation-file-format.github.io/
[citation]: ./CITATION.cff

[senseslab]: https://senseslab.diag.uniroma1.it/
[docker-license]: ./LICENSE
[ns3-license]: https://www.nsnam.org/develop/contributing-code/licensing/
