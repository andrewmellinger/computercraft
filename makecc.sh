#/bin/bash

# Copy the lua files to the other directory with the lua
# Zip the other directory.

# This is where the source code is
export SRC="."

# This is where the rest of the CC is that we overlay into.
export DST="../cc"

# Traverse all the files.
LIST="$(find $SRC/rom/programs)"
REGEX="(.*)\.lua"
for FILE in $LIST
do
  FILE=${FILE#$SRC}
  if [[ $FILE =~ $REGEX ]]; then
    OUTFILE="${BASH_REMATCH[1]}"
    echo "cp $SRC$FILE $DST$OUTFILE"
  else
    echo "cp $SRC$FILE $DST$FILE"
  fi
done

# Zip the whole thing up
# zip -r 

# Remove old file zip file in the new directory
# rm 

# Copy the file to the right directory
# mv
