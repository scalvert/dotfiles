function find_engines
  find . -name '*ember-config.js' -print0 | xargs -0 -n1 dirname | sed -E 's/^.{2}//' | sort --unique
end
