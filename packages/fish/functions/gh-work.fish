function gh-work --description "Switch to work GitHub account (steve-calvert-glean) with SSH"
    gh auth switch --user steve-calvert-glean
    gh config set git_protocol ssh --host github.com
    echo "Switched to steve-calvert-glean (work) with SSH"
end
