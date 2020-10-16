function lint_set_response
  for dir in "core" "extended" "lib" "engine-lib"
    set -l value (./node_modules/.bin/eslint --no-eslintrc --plugin "@linkedin/eslint-plugin-pemberly" --parser "babel-eslint" --rule "@linkedin/pemberly/set-response-mock-required: 2" --ignore-pattern "tmp/**"  "./$dir/**/*-test.js" | sed '/^\s*$/d' | tail -n 1)
    echo "$dir $value"
  end
end
