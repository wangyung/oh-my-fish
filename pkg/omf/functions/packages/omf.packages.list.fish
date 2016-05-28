set -l builtin_package_path {$OMF_PATH,$OMF_CONFIG}/pkg*/{omf,fish-spec}

function __omf.packages.format
  set IFS /
  for path in $argv
    echo $path | read -la components
    echo $components[-1]
  end
end

function __omf.packages.list.available -a type
  set -l list
  set -l database_package_path $OMF_PATH/db/pkg/*
  set -l database_theme_path $OMF_PATH/db/themes/*
  set -l installed_package_path {$OMF_CONFIG,$OMF_PATH}/pkg/*
  set -l installed_theme_path {$OMF_CONFIG,$OMF_PATH}/themes/*

  test "$type" = "--theme"; or for path in $database_package_path
    contains $path $installed_package_path; or set list $list $path
  end

  test "$type" = "--plugin"; or for path in $database_theme_path
    contains $path $installed_theme_path; or set list $list $path
  end

  __omf.packages.format $list
end

function __omf.packages.list.database -a type
  set -l list
  set -l database_package_path $OMF_PATH/db/pkg/*
  set -l database_theme_path $OMF_PATH/db/themes/*

  test "$type" = "--theme"; or for path in $database_package_path
    set list $list $path
  end

  test "$type" = "--plugin"; or for path in $database_theme_path
    set list $list $path
  end

  __omf.packages.format $list
end

function __omf.packages.list.installed -a type
  set -l list
  set -l installed_package_path $OMF_PATH/pkg/*
  set -l installed_theme_path $OMF_PATH/themes/*

  echo $type

  test "$type" = "--theme"; or for path in $installed_package_path
    contains $path $builtin_package_path; or set list $list $path
  end

  test "$type" = "--plugin"; or for path in $installed_theme_path
    set list $list $path
  end

  __omf.packages.format $list
end

function omf.packages.list
  set type_index (begin
    contains -i -- --theme $argv
    contains -i -- -t $argv
    contains -i -- --plugin $argv
    contains -i -- -p $argv
  end)

  set option_index (begin
    contains -i -- --available $argv
    contains -i -- -a $argv
    contains -i -- --installed $argv
    contains -i -- -i $argv
    contains -i -- --database $argv
    contains -i -- -d $argv
  end)

  set option $argv[$option_index]
  set type $argv[$type_index]

  switch "$option"
  case "-a" "--available"
    __omf.packages.list.available $type
  case "-d" "--database"
    __omf.packages.list.database $type
  case "-i" "--installed"
    __omf.packages.list.installed $type
  case "*"
    __omf.packages.list.installed $type
  end
end
