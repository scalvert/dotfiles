function rb_open_all
  set -l username $argv[1]
  for id in (curl "https://rb.corp.linkedin.com/api/review-requests/?from-user=$username&status=submitted" | jq '.review_requests[].id')
     open "https://rb.corp.linkedin.com/r/$id"
  end
end
