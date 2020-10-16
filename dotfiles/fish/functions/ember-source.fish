function ember-source -a query
  if not test -e ~/ember-source/globals.json
    mkdir ~/ember-source;
    curl https://raw.githubusercontent.com/ember-cli/ember-rfc176-data/master/globals.json > ~/ember-source/globals.json
  end

  ag --silent --nonumbers  --nocolor --ignore-case $query ~/ember-source/globals.json
end
