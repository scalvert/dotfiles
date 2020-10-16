function codemod_ember_onerror
  for dir in "core" "extended" "engine-lib" "lib"
    ember-test-onerror-codemod remove-onerror-assignments $dir/**/*-test.js
    ember-test-onerror-codemod remove-onerror-sinon-stubs $dir/**/*-test.js
  end
end
