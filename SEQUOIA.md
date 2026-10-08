# TypeTide for macOS Sequoia

Local port of everettjf/typetide at commit cca719d8157eb0497e60fc1c4f4c65bbcee5a43f.

Requires macOS 15 or later. The supplied app targets Apple Silicon and was built
with Xcode 16.4 / Swift 6.1.2 on macOS 15.7.7.

Changes:
- Lower app and test deployment targets to macOS 15.
- Pin MLX Swift LM 2.29.3 and MLX Swift 0.29.1 with a resolved dependency lockfile.
- Replace Swift 6.2 default actor isolation with explicit main-actor annotations.
- Use Swift 6.1 nonisolated async execution for model download and verification.
- Adapt offline generation and cache release to the compatible MLX API. Streaming,
  per-token cancellation, input/output limits, and serialized model access remain.
- Prevent upstream macOS 26 update prompts on Sequoia.

## Rebuild

From this repository's root:

```sh
./macos/scripts/build-sequoia.sh
```

By default the script uses ad-hoc signing. To use an existing development
certificate for stable Accessibility permissions:

```sh
DEVELOPMENT_TEAM=YOUR_TEAM_ID CODE_SIGN_IDENTITY='Apple Development' \
  ./macos/scripts/build-sequoia.sh
```

The script builds an arm64 Release app in macos/build-sequoia/Build/Products/Release.
It does not publish, notarize, or alter version numbers. Select your own signing
team when building directly in Xcode.

## Validation

The existing XCTest suite passed on macOS 15.7.7: 33 passed, 3 opt-in integration
tests skipped, 0 failures. This includes the production popup/stream/replacement
flow using a mock provider, OpenAI streaming parsing, language/prompt contracts,
clipboard restoration, resumable download checks, and cancellation behavior.

Live MLX model inference, live Hugging Face downloads, and live Ollama translation
were not verified. Hugging Face TLS connections failed from the build machine.
The offline model still requires its normal 2.22 GB download in Settings; Ollama
and OpenAI-compatible backends remain available.

The Release build succeeded, passed strict recursive signature verification, and
launched on macOS 15.7.7. Its Mach-O minimum OS and Info.plist both specify 15.0.

The supplied app is locally Apple Development signed, not Developer ID notarized.
Grant TypeTide Accessibility access in System Settings > Privacy & Security to
capture text and replace it in other apps.
