#! /bin/sh

if [[ -z $(git status -s | grep _site) ]]; then
    echo "Nothing to publish"
else
    git config --global user.email kevin@idempotent.ca
    git config --global user.name "Kevin Jing Qiu"
    git stash && git checkout master && git stash pop
    git add _sites
    git commit -m "Publish Site"
    git push origin master
fi
