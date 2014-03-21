#/bin/bash

# Copy the lua files to the other directory with the lua
# Zip the other directory.

# Where the cc scripts are kept.  Parent of "rom"
LUA_SRC_DIR=""

# Where the exploded CC directory is that we'll copy things into. "Parent of assets"
# This is what will be zipped
CC_MOD_DIR=""

## Where the MC mods go
MC_MODS_DIR=""

CC_ZIP_FILE_NAME="ComputerCraftModified.zip"

if [ -e "./makecc.config" ]; then
  source "./makecc.config"
fi

echo "LUA_SRC_DIR: $LUA_SRC_DIR"
echo "CC_MOD_DIR:  $CC_MOD_DIR"
echo "MC_MODS_DIR: $MC_MODS_DIR"

LUA_DST_DIR="$CC_MOD_DIR/assets/computercraft/lua"

# Traverse all the files.
LIST="$(find $LUA_SRC_DIR/rom)"
REGEX="(.*)\.lua"
for FILE in $LIST; do
  if [ -f $FILE ]; then
    FILE=${FILE#$LUA_SRC_DIR}
    if [[ $FILE =~ $REGEX ]]; then
      OUTFILE="${BASH_REMATCH[1]}"
      cp $LUA_SRC_DIR$FILE $LUA_DST_DIR$OUTFILE
    else
      cp $LUA_SRC_DIR$FILE $LUA_DST_DIR$FILE
    fi
  fi
done

# Zip the whole thing up
pushd $CC_MOD_DIR
zip -r ../$CC_ZIP_FILE_NAME .
popd

# Remove old zip file in the new directory
if [ -f "$MC_MODS_DIR/$CC_ZIP_FILE_NAME" ]; then
  echo "Removing: $MC_MODS_DIR/$CC_ZIP_FILE_NAME"
  rm "$MC_MODS_DIR/$CC_ZIP_FILE_NAME"
fi

# Copy the file to the right directory
if [ -f "$CC_MOD_DIR/../$CC_ZIP_FILE_NAME" ] ; then
  echo "Moving: $CC_MOD_DIR/../$CC_ZIP_FILE_NAME -to- $MC_MODS_DIR/$CC_ZIP_FILE_NAME"
  mv "$CC_MOD_DIR/../$CC_ZIP_FILE_NAME" "$MC_MODS_DIR/$CC_ZIP_FILE_NAME"
fi
