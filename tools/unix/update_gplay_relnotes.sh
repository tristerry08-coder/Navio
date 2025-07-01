#!/usr/bin/env bash

# Concatenates Android release notes in all languages into a single output format
# suitable to upload to Google Play to add or update existing notes.

# Original relnotes files:
GPLAY_NOTES=android/app/src/fdroid/play/listings/*/release-notes.txt
# also symlinked for Triple-T automation to android/app/src/google/play/release-notes/*/default.txt

for x in $(ls $GPLAY_NOTES); do
  l=$(basename $(dirname $x));
  echo "<"$l">";
  cat $x;
  echo "</"$l">";
done
