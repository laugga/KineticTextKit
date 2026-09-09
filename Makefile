SCHEME := KineticTextKit

BUILD_DEST := generic/platform=iOS Simulator

.PHONY: help build test clean

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
