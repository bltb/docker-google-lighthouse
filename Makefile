CACHE ?= --no-cache=1
VERSION ?= v3.2.1
FULLVERSION ?= v3.2.1
archs ?= arm32v7 amd64 i386
.PHONY: all build publish latest
all: build publish latest
qemu-arm-static:
	cp /usr/bin/qemu-arm-static .
build: qemu-arm-static
	$(foreach arch,$(archs), \
		docker build -t femtopixel/google-lighthouse:${VERSION}-$(arch) -f Dockerfile.$(arch) ${CACHE} .;\
	)
publish:
	docker push femtopixel/google-lighthouse
	cat manifest.yml | sed "s/\$$VERSION/${VERSION}/g" > manifest2.yaml
	cat manifest2.yaml | sed "s/\$$FULLVERSION/${FULLVERSION}/g" > manifest.yaml
	manifest-tool push from-spec manifest.yaml
latest: build
	FULLVERSION=latest VERSION=${VERSION} make publish
