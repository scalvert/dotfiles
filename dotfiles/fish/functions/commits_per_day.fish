function commits_per_day
  for NUM in (seq 30)
    git log --since="$NUM.day.ago" | wc -l
  end
end
