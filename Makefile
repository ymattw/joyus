.PHONY: build serve server clean

serve server:
	jekyll serve

build:
	jekyll build --safe

clean:
	rm -rf _site
