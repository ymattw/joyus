.PHONY: build serve server clean new

serve server:
	docker run -it --rm \
		-v "$(shell pwd)":/usr/src/app \
		-p "4000:4000" \
		starefossen/github-pages

build:
	jekyll build --safe

clean:
	rm -rf _site

TITLE ?= TODO
URI := $(shell echo "$(TITLE)" | sed -e 's/[^a-zA-Z0-9 -]//g' -e 's/ /-/g' | tr A-Z a-z)
DATE := $(shell date '+%Y-%m-%d')
POST = _posts/$(DATE)-$(URI).md

new:
	@echo "---" > $(POST)
	@echo "layout: post" >> $(POST)
	@echo "title: $(TITLE)" >> $(POST)
	@echo "tags: []" >> $(POST)
	@echo "---" >> $(POST)
	@echo $(POST)
