#! /bin/bash


if [[ -z $(git status -s) ]]; then
    echo "Nothing to publish"
else
    git config --global user.email kevin@idempotent.ca
    git config --global user.name "Kevin Jing Qiu"
    git stash && git checkout master && git stash pop
    git commit -am "Publish Site"
    git push origin master
fi
