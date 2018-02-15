#! /bin/bash


if [[ -z $$(git status -s) ]]; then
    git config --global user.email kevin@idempotent.ca
    git config --global user.name "Kevin Jing Qiu"
    git stash && git checkout master && git stash pop
    git commit -am "Publish Site"
    git push origin master
else
    echo "Nothing to publish"
fi
