function find_by_type
  set type (string join '' '*/' $argv '/*')
  find core extended lib engine-lib -path $type -type f -name '*.js' | wc -l
end
