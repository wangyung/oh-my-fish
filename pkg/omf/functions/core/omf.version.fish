function omf.version
  command git -C "$OMF_PATH" describe --tags --match 'v*' --abbrev=0 --always | sed 's/^v\([[:digit:]]\+\)/\1/'
end
