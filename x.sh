#!/bin/sh

set -o errexit -o nounset

# required for git operations
git config user.name "Cole Miller"
git config user.email "m@cole-miller.net"

# build step
for md in $(echo *.md); do
	cmark <"$md" >"www/${md%.md}.html"
done

# arrange the content
find . -maxdepth 1 -mindepth 1 '!' '(' -name .git -or -name www ')' -exec rm -r '{}' '+'
find www -maxdepth 1 -mindepth 1 -exec mv -t . '{}' '+'
rmdir www
touch .nojekyll

# create the commit
git checkout --orphan tmp
git add -A
git commit -m "website!"

# tell github about it
git branch gh-pages
git push -f origin gh-pages
