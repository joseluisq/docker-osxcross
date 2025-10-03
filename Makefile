REPOSITORY ?= joseluisq
TAG ?= latest

build:
	docker build \
		-t $(REPOSITORY)/docker-osxcross:$(TAG) \
		--network=host \
		-f docker/amd64/Dockerfile .
.PHONY: build

# Use to build both arm64 and amd64 images at the same time.
# WARNING! Will automatically push, since multi-platform images are not available locally.
# Use `REPOSITORY` arg to specify which container repository to push the images to.
buildx:
	docker run --privileged --rm tonistiigi/binfmt --install linux/amd64,linux/arm64
	docker buildx create --name darwin-builder --driver docker-container --bootstrap
	docker buildx use darwin-builder
	docker buildx build \
		--platform linux/amd64,linux/arm64 \
		--push \
		-t $(REPOSITORY)/docker-osxcross:$(TAG) \
		-f docker/amd64/Dockerfile .

.PHONY: buildx

run:
	@docker run --rm -it \
		-v $(PWD):/root/src \
		-w /root/src \
			$(REPOSITORY)/docker-osxcross:$(TAG) \
				bash
.PHONY: run
