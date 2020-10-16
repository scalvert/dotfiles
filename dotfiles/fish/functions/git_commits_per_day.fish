function git_commits_per_day
  git log --date=short --pretty=format:%ad | sort | uniq -c
end
