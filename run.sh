#!/bin/sh

# Copyright (c) 2013 Matthias Rampke <mr@soundcloud.com>
#
# Permission to use, copy, modify, and/or distribute this software for any
# purpose with or without fee is hereby granted, provided that the above
# copyright notice and this permission notice appear in all copies.
#
# THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
# WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
# MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
# ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
# WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
# ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
# OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.

# go wherever this script lives
cd $(dirname $0)

# test environment
if [ -z "$PORT" ]
then
  PORT=8080
  export PORT
fi

# set dummy revision if none passed in
if [ -z "$REVISION" ]
then
  REVISION="None"
  export REVISION
fi

if [ -d /dev/shm ]
then
  TMPDIR=/dev/shm
else
  TMPDIR=/tmp
fi

cat >$TMPDIR/man-$REVISION-$PORT.conf <<EOF
daemon off;
lock_file $TMPDIR/man-$REVISION-$PORT.lock;
pid $TMPDIR/man-$REVISION-$PORT.pid;

events {

}

http {
  access_log off;
  error_log stderr info;

  client_body_temp_path $TMPDIR/man-$REVISION-$PORT;

  server {
    listen *:$PORT;

    set \$revision "$REVISION";

    include $PWD/nginx_mdoc.conf;
  }
}
EOF

exec $PWD/nginx -c /$TMPDIR/man-$REVISION-$PORT.conf
