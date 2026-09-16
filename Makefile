# The package's build, test and clean (CONVENTIONS.md → Swift library,
# OPS-12); the Example app has its own in Example/. deploy is the only one of
# the Example's targets exposed here, and it delegates — it is the try-it
# signal an agent and repo-doctor read off this file.

SCHEME := KineticTextKit

BUILD_DEST := generic/platform=iOS Simulator

.PHONY: help build test clean deploy

help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | \
		awk 'BEGIN {FS = ":.*?## "}; {printf "  make %-8s %s\n", $$1, $$2}'

build:
	xcodebuild build -scheme $(SCHEME) -destination '$(BUILD_DEST)'

test:
	@dev="$${TEST_DEVICE:-$$(xcrun simctl list devices available | grep -oE 'iPhone [0-9]+[^(]*' | tail -1 | xargs)}"; \
	dest="$${TEST_DEST:-platform=iOS Simulator,name=$$dev}"; \
	echo "Testing on: $$dest"; \
	xcodebuild test -scheme $(SCHEME) -destination "$$dest"

clean:
	xcodebuild clean -scheme $(SCHEME)
	rm -rf .build

# Work on the Example app directly with `make -C Example build|test|archive`,
# including `make -C Example clean` — this root clean is the package's only.
# Only deploy is exposed here, because only deploy is the convention's promise
# to the outside: it says this repository has something to try.

deploy: ## Build and upload the Example app to Firebase App Distribution
	$(MAKE) -C Example deploy
