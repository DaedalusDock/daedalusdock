## Daedalus Dock codebase

[![CI Suite](https://github.com/DaedalusDock/daedalusdock/actions/workflows/ci_suite.yml/badge.svg)](https://github.com/DaedalusDock/daedalusdock/actions/workflows/ci_suite.yml)
[![Percentage of issues still open](https://isitmaintained.com/badge/open/DaedalusDock/daedalusdock.svg)](https://isitmaintained.com/project/DaedalusDock/daedalusdock "Percentage of issues still open")
[![Average time to resolve an issue](https://isitmaintained.com/badge/resolution/DaedalusDock/daedalusdock.svg)](https://isitmaintained.com/project/DaedalusDock/daedalusdock "Average time to resolve an issue")
![Coverage](https://img.shields.io/badge/coverage-no%25-red.svg)

[![resentment](.github/images/badges/built-with-resentment.svg)](.github/images/comics/131-bug-free.png) [![technical debt](.github/images/badges/contains-technical-debt.svg)](.github/images/comics/106-tech-debt-modified.png) [![forinfinityandbyond](.github/images/badges/made-in-byond.gif)](https://www.reddit.com/r/SS13/comments/5oplxp/what_is_the_main_problem_with_byond_as_an_engine/dclbu1a)

* **Website:** https://daedalus13.net
* **Code:** https://github.com/DaedalusDock/daedalusdock
* **Wiki:** https://wiki.daedalus13.net/Main_Page
* **Codedocs:** https://codedoc.daedalus13.net/
* **Daedalus Dock Discord:** https://discord.gg/bttwJmfznH
* **Coderbus Discord:** https://discord.gg/Vh8TJp9

This is the codebase for the nightmare amalgamation of /TG/station, Goonstation, and Baystation12 codebases for the game Space Station 13.

Space Station 13 is a round-based roleplaying game set on a cassette-futuristic station where every job from Clown to Head of Security is played by users. Watch out for shifty individuals, as you may be subject to kidnapping, blood sacrifice, murder, or a dock in pay from a particularly upset Head of Personnel.

## DOWNLOADING
[Downloading](.github/guides/DOWNLOADING.md)

[Running on the server](.github/guides/RUNNING_A_SERVER.md)

[Maps and Away Missions](.github/guides/MAPS_AND_AWAY_MISSIONS.md)

## :exclamation: How to compile :exclamation:

On **2021-01-04**, /TG/station changed the way to compile the codebase.

**The quick way**. Find `bin/server.cmd` in this folder and double click it to automatically build and host the server on port 1337.

**The long way**. Find `bin/build.cmd` in this folder, and double click it to initiate the build. It consists of multiple steps and might take around 1-5 minutes to compile. If it closes, it means it has finished its job. You can then [setup the server](.github/guides/RUNNING_A_SERVER.md) normally by opening `daedalus.dmb` in DreamDaemon.

**Building in DreamMaker directly is now deprecated and might produce errors**, such as `'tgui.bundle.js': cannot find file`.

**[How to compile in VSCode and other build options](tools/build/README.md).**

## Contributors
[Guides for Contributors](.github/CONTRIBUTING.md)

## LICENSE

All code after [commit 333c566b88108de218d882840e61928a9b759d8f on 2014/31/12 at 4:38 PM PST](https://github.com/DaedalusDock/Gameserver/commit/333c566b88108de218d882840e61928a9b759d8f) is licensed under [GNU AGPL v3](https://www.gnu.org/licenses/agpl-3.0.html).

All code before [commit 333c566b88108de218d882840e61928a9b759d8f on 2014/31/12 at 4:38 PM PST](https://github.com/DaedalusDock/Gameserver/commit/333c566b88108de218d882840e61928a9b759d8f) is licensed under [GNU GPL v3](https://www.gnu.org/licenses/gpl-3.0.html).
(Including tools unless their readme specifies otherwise.)

See LICENSE and GPLv3.txt for more details.

The TGS DMAPI API is licensed as a subproject under the MIT license.

See the footer of [code/__DEFINES/tgs.dm](./code/__DEFINES/tgs.dm) and [code/modules/tgs/LICENSE](./code/modules/tgs/LICENSE) for the MIT license.

All assets including icons and sound are under a [Creative Commons 3.0 BY-SA license](https://creativecommons.org/licenses/by-sa/3.0/) unless otherwise indicated.
