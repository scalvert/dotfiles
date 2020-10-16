function sync_fork
    set current_branch = (git rev-parse --abbrev-ref HEAD)

    git fetch upstream
    git checkout master
    git merge upstream/master

    git push origin master

    git checkout $current_branch
end
