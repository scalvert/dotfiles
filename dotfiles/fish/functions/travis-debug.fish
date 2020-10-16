function travis-debug
  set url https://api.travis-ci.org/job/$argv/debug
  curl -s -X POST -H "Content-Type: application/json" -H "Accept: application/json" -H "Travis-API-Version: 3" -H "Authorization: token bPauw4UN0arXk1PoLTOFzw" -d '{ "quiet": true }' $url 
end
