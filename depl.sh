#!/usr/bin/env bash
npm run build
rm -r docs
cp -r dist docs

git commit -a -m "update docs"
git push