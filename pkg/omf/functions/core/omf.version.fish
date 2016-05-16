function omf.version
  if set -l tag (command git -C "$OMF_PATH" describe --tags --match 'v*' --exact-match ^ /dev/null)
    echo $tag | cut -c 2-
  else
    echo (command git -C "$OMF_PATH" describe --tags --match 'v*' --abbrev=0 --always | cut -c 2-)-dev
  end
end
