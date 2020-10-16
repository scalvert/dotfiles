function rb_repos_by_user
  set -l username $argv[1]
  curl "https://rb.corp.linkedin.com/api/review-requests/?from-user=$username&status=submitted" | jq -r '.review_requests[] .links.repository.title' | sort | uniq
end
