function codemod_sinon
  for dir in "core" "extended" "engine-lib" "lib"
    jscodeshift -t https://raw.githubusercontent.com/scalvert/sinon-codemod/master/extract-calls-fake.js $dir/**/*-test.js
  end
end
