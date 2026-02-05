function gh-personal --description "Switch to personal GitHub account (scalvert) with HTTPS"
    gh auth switch --user scalvert
    gh config set git_protocol https --host github.com
    echo "Switched to scalvert (personal) with HTTPS"
end
