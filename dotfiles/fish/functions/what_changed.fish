function what_changed -a repo range
  open https://github.com/$repo/compare/master@\{$range\}...master
end
