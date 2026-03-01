TARGET_ROOT ?= /mnt
USER ?=

.PHONY: install
install:
	@if [ -z "$(USER)" ]; then \
		echo "USER is required (example: make install USER=alice)"; \
		exit 2; \
	fi
	./run.sh "$(TARGET_ROOT)" "$(USER)"
