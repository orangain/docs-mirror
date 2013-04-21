#!/bin/sh

set -e

BASE_DIR=/opt/docs-mirror
DOWNLOAD_DIR=$BASE_DIR/downloads
STATIC_DIR=$BASE_DIR/static
DOC_ROOT=$BAE_DIR/public

setup() {
	mkdir -p $DOWNLOAD_DIR
	mkdir -p $DOC_ROOT

	cd $DOWNLOAD_DIR
	hg clone http://hg.python.org/cpython

	hg clone $DOWNLOAD_DIR/cpython python-2
	hg clone $DOWNLOAD_DIR/cpython python-3
	cd $DOWNLOAD_DIR/python-2
	hg checkout 2.7
	cd $DOWNLOAD_DIR/python-3
	hg checkout 3.3

	ln -s $DOWNLOAD_DIR/cpython/Doc/build/html $DOC_ROOT/pydev
	ln -s $DOWNLOAD_DIR/python-2/Doc/build/html $DOC_ROOT/py2
	ln -s $DOWNLOAD_DIR/python-3/Doc/build/html $DOC_ROOT/py3
	ln -s $STATIC_DIR/robots.txt $DOC_ROOT/
}

update() {
	cd $DOWNLOAD_DIR/cpython
	hg pull --update
	cd Doc
	make html

	cd $DOWNLOAD_DIR/python-2
	hg pull --update
	cd Doc
	make html

	cd $DOWNLOAD_DIR/python-3
	hg pull --update
	cd Doc
	make html
}

usage() {
	echo "Usage: mirror.sh setup" >&2
	echo "       mirror.sh update" >&2
}

case $1 in
	setup) setup ;;
	update) update ;;
	*) usage ;;
esac
