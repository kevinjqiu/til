index:
	markdown-index t > README.md
	git commit -am "Update Index"

install:
	sudo npm install -g markdown-index
