#!/bin/sh
destdir="/apps/sc3repo/el/6/products"
for arch in SRPMS i386 x86_64
do
   pushd ${destdir}/${arch} >/dev/null 2>&1
       createrepo .
   popd >/dev/null 2>&1
done

#destdir="/apps/sc3repo/el/6/products"
#createrepo $destdir

