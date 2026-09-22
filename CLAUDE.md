Generative AI, including large language models (LLMs), should not be used in
any way when contributing to SDL.

We want our code to be art. We want to interact with real humans. Please don't
submit AI-generated comments or code in bug reports or pull requests. We
understand some people consider AI to be a useful tool, but we want to connect
with you, not your computer.

Any pull request to this project will ask you to confirm that you are the
author and that you are contributing your changes under the zlib license.


---

## This fork (matthewdeaves/SDL-1.2): retro floor branches

A personal fork used only to build and maintain the SDL 1.2 that the private
fleet of Mac OS X ports (QuakeSpasm, Quake II, Quake III) ships. It is never
used to file, comment on, or send pull requests to libsdl-org/SDL-1.2. The
policy above covers upstream contribution and doesn't apply to work kept
entirely on this fork. Issues are off here; tickets live in
matthewdeaves/SDL (the SDL2 sibling fork, same owner). `upstream` is fetch
only.

Licence: SDL 1.2 is **LGPL 2.1** (`COPYING`), not zlib like SDL2. Keep
`COPYING`. The ports load it as a separate dynamic library.

### What the fleet ships today (measured 2026-09-22, matthewdeaves/SDL#4)

One SDL 1.2 build, vendored in three ports' git trees:
`SDL.framework/Versions/A/SDL` (quakespasm, quake2) and
`libSDL-1.2.0.dylib` (quake3, the same bytes plus `install_name_tool -id`).
Its members have **different sources**:

| Slice | Source | Floor |
|---|---|---|
| ppc | SDL **1.2.15 release tarball** (sha256 `d6d316a7...`), built with old-mac-quakespasm's `MacOSX/SDL-rebuild.md` recipe | 10.3 (10.3.9 SDK link: libSystem 71.1.3, Cocoa 9) |
| x86_64, i386 | upstream QuakeSpasm commit `0798fa95` (2025-02-26): SDL-1.2 git, headers byte-identical to `73533a6a`; Info.plist 1.2.16, built on 10.7.2 | not recorded in the binary |
| arm64 | sdl12-compat `release-1.2.76` over SDL 2.32.4, built by each port's `build-arm64.sh` | 11.0 |

### Branches

| Branch | Base | Commits on top | Status |
|---|---|---|---|
| `retro/panther-ppc` | `release-1.2.15` (`457d4e55`) | tarball's generated build files; `retro/build-ppc-panther.sh` (the quakespasm recipe); cherry-pick of upstream `61074e09` (SDL#5: 1.2.15 rejects non-32-bpp desktops) | **canonical** for the ppc/10.3 floor |

Tags:

- `retro/panther-ppc-base` (`1b8e15ae`): rebuilds the slice the fleet
  ships today **byte-identically** (sha256 `d92222069edfefc9…`; SDL#4).
- `retro/panther-ppc-sdl5-fix` (`d298f453`): base plus `61074e09`. Built
  slice sha256 `07cc046e76f0e71a82434cc5f23a402a1e7cc2a4383baa11c8c3553aac554401`.
  Tested on yosemite (G3, 10.3.9, 2026-09-22) with Quake II: the shipped
  slice fails at 16 bpp with `Couldn't init SDL video: Unsupported display
  mode`, and this one passes the timedemo at both 16 and 32 bpp (SDL#5).

Both slices audit identically at the 10.3 floor: 195 hard imports, all
present in 10.3.9. `_CGBitmapContextCreateImage` is missing from the SDK
headers but exported by Panther's real CoreGraphics.

The Intel slices have no branch yet: upstream QuakeSpasm's build is already
a newer SDL-1.2 than 1.2.15 and already contains `61074e09`.

### Build and verify

On a Lion build mini, claimed with
`old-mac-build-host/scripts/pick-build-host.sh`:

```sh
sh retro/build-ppc-panther.sh /path/out.dylib [install-name]
```

Floor audit, from matthewdeaves/SDL:
`scripts/weak-link-audit.sh <slice> 10.3 /Developer/SDKs/MacOSX10.3.9.sdk`.
Modern `lipo` can't extract ppc members and modern `install_name_tool`
can't write them. Split fat files by parsing the fat header, and compare
ppc slices by load command (see SDL#4).

### Boundaries

Same as matthewdeaves/SDL. Buildhost owns machines and pickers, and the
ports own their vendored binaries and build drivers. The hand-off is always
a branch, a tag and a commit hash by mail.
