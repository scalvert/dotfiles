function ember_types
  for package in "ember__array" "ember__object" "rsvp" "htmlbars-inline-precompile" "ember__service" "ember__controller" "ember__string" "ember__polyfills" "ember__utils" "ember__runloop" "ember__debug" "ember__engine" "ember__application" "ember__test" "ember__array" "ember__error" "ember__component" "ember__routing" "jquery" "ember__string" "ember__polyfills" "ember__object" "ember__utils" "ember__engine" "ember__debug" "ember__runloop" "ember__error" "ember__controller" "ember__component" "ember__routing" "ember__application" "ember__test" "ember__service"
    echo "@types/$package" && yarn info @types/$package version --silent
  end
end
