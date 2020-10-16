function delete-local-branches
  git branch | grep -v "master" | xargs git branch -D
end
