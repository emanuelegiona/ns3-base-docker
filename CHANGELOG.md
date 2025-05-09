# Changelog

## Release v1.1.0

[Link to release][v110]

Added support for more recent Boost C++ library in `egiona/ns3-base:u18.04-*` image family. 

More specifically, the default Boost version (available in Ubuntu 18.04) is upgraded to [v1.74][boost-v174] through an external PPA repository, namely [`ppa:mhier/libboost-latest`][ppa-boost].

Newly added image tags are:

- `u18.04-n3.35-boosted`

- `u18.04-n3.34-boosted`

- `u18.04-n3.33-boosted`

where ns-3 is built against the upgraded version of Boost C++ libraries.

Such libraries are available in their default installation directories, and dedicated environment variables are made available for improved user experience:

| Environment variable name | Value | Notes |
|:---:|:---|:---:|
| `NEW_BOOST_INCLUDES` | `/usr/include` | Absolute path to Boost header files</br>(parent directory) |
| `NEW_BOOST_LIBS` | `/usr/lib/` | Absolute path to Boost library objects</br>(parent directory) |

## Release v1.0.0

[Link to release][v100]

`ns3-base` initial release.

Images follow the same Dockerfile structure and additional utilities as seen in [`ns3-woss` v2.0.1][img-inspo] and later versions.

Supported versions:

- OS: Ubuntu 18.04 LTS, 20.04 LTS, 22.04 LTS

- ns-3: from 3.33 to 3.41



<!--- Releases --->
[v110]: https://github.com/emanuelegiona/ns3-base-docker/releases/tag/v1.1.0
[boost-v174]: https://www.boost.org/users/history/version_1_74_0.html
[ppa-boost]: https://launchpad.net/~mhier/+archive/ubuntu/libboost-latest

[v100]: https://github.com/emanuelegiona/ns3-base-docker/releases/tag/v1.0.0
[img-inspo]: https://github.com/SENSES-Lab-Sapienza/ns3-woss-docker/releases/tag/v2.0.1
