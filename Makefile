.PHONY: build serve server clean

build:
	jekyll build --safe

serve server:
	jekyll serve

clean:
	rm -rf _site
