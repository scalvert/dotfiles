function changes_over_year
  git log --shortstat --since "1 year ago" --until "1 day ago" | grep "files changed" | awk '{files+=$1; inserted+=$4; deleted+=$6} END {print "files changed", files, "lines inserted:", inserted, "lines deleted:", deleted}'
end
