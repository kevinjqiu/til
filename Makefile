npmbin := ./node_modules/.bin
PORT ?= 3000

# Builds intermediate files. Needs a _site built first though
update: _site critical

# Builds _site
_site:
	bundle exec jekyll build

# Builds critical path CSS/JS
critical: _site
	node _support/critical.js

# Starts development server
dev:
	$(npmbin)/concurrently -k -p command -c "blue,green" \
		"make dev-webpack" \
		"make dev-jekyll"

dev-webpack:
	$(npmbin)/webpack --watch --colors -p

dev-jekyll:
	if [ -f _site ]; then \
		bundle exec jekyll serve --safe --trace --drafts --watch --incremental --port $(PORT); \
		else \
		bundle exec jekyll serve --safe --trace --drafts --watch --port $(PORT); \
		fi

setup:
	bundle install && npm install

build-docker:
	docker build -t kevinjqiu/til-build .

publish:
	git config --global user.email kevin@idempotent.ca
	git config --global user.name "Kevin Jing Qiu"
	git commit -am "Publish Site"
	git push origin master
