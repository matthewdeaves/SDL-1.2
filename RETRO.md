# Retro branch (matthewdeaves/SDL-1.2)

This fork keeps the SDL 1.2 PowerPC build that the old-mac ports of
QuakeSpasm, Quake II and Quake III ship, for Mac OS X 10.3 and later. `main`
follows upstream and isn't used for builds. Issues live in the SDL2 sibling
fork, [matthewdeaves/SDL](https://github.com/matthewdeaves/SDL).

| Branch | Tag | What it is |
|---|---|---|
| `retro/panther-ppc` | `retro/panther-ppc-base` | SDL `release-1.2.15`, plus the tarball's generated build files and `retro/build-ppc-panther.sh`. Rebuilds the PowerPC slice the ports shipped before SDL#5, byte for byte (SDL#4). |
| | `retro/panther-ppc-sdl5-fix` | Base plus upstream `61074e09`: 1.2.15 refused non-32-bpp desktops ("Unsupported display mode"). Tested on a G3 at 10.3.9, at 16 and 32 bpp (SDL#5). |

The [release](https://github.com/matthewdeaves/SDL-1.2/releases) of
`retro/panther-ppc-sdl5-fix` carries the built ppc slice, `SHA256SUMS`, and
`setdepth-ppc`, the display-depth switcher used for the 16-bpp test.

The ports' other slices don't come from this fork. x86_64 and i386 come from
upstream QuakeSpasm's SDL-1.2 build, which already includes `61074e09`.
arm64 is sdl12-compat `release-1.2.76` over SDL 2.32.4.

Build (on a 10.7 Intel Mac with the 10.3.9 SDK):
`sh retro/build-ppc-panther.sh <out.dylib> [install-name]`. Floor audit:
`scripts/weak-link-audit.sh <slice> 10.3 <MacOSX10.3.9.sdk>` from
matthewdeaves/SDL.

SDL 1.2 is LGPL 2.1 (`COPYING`); the ports load it as a separate dynamic
library.
