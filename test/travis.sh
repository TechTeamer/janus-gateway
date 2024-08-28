#!/bin/bash
set -ev

# Help: https://docs.travis-ci.com/user/job-lifecycle/

# Fordítási és telepítési lépések
sh autogen.sh
./configure
make

# Tesztek futtatása
make check

# Alternatív tesztfuttatás, ha a make check nem futtatja az összes tesztet
# cd test
# ./some_test_script.sh

# Ellenőrizzük, hogy a git diff visszatér-e változásokkal
git diff --exit-code -- .

# Ellenőrizzük, hogy vannak-e nem megfelelően futtatható fájlok
IGNORED_EXECUTABLES='^./bin/|^./.git/|^./node_modules/|^./test/travis.sh$'

if [[ `find -type f -executable -exec echo '{}' \; | grep -vP $IGNORED_EXECUTABLES | wc -l` -gt 0 ]]; then
  echo "Found executables in the wrong folder:"
  find -type f -executable -exec echo '{}' \; | grep -vP $IGNORED_EXECUTABLES
  exit 1
fi
