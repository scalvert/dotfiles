function git-tree --description "Show git diff as a tree-like structure"
    git diff --name-only | sort | awk '
  function repeat(s, n,    out) {
    out = ""
    for (i = 0; i < n; i++) out = out s
    return out
  }

  {
    split($0, parts, "/")
    path = ""
    for (i = 1; i <= length(parts); i++) {
      path = (i == 1 ? parts[i] : path "/" parts[i])
      if (!(path in seen)) {
        seen[path] = 1
        indent = ""
        for (j = 1; j < i; j++) {
          indent = indent "│   "
        }
        prefix = (i == length(parts)) ? "└── " : "├── "
        print indent prefix parts[i]
      }
    }
  }'
end

