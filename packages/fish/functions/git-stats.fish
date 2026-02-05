function git-stats
    # count tracked files
    set file_count (git ls-files | wc -l | string trim)

    # sum byte sizes recorded in HEAD, then auto‑humanize
    set human_size (git ls-tree -r -l HEAD | awk '
        {sum += $4}
        END {
            split("B KiB MiB GiB TiB PiB", u)
            for (i = 1; sum >= 1024 && i < 6; i++) sum /= 1024
            printf "%.2f %s\n", sum, u[i]
        }' | string trim)

    # total commits (all branches)
    set commit_count (git rev-list --all --count | string trim)

    # on‑disk packfile size (all history)
    set pack_size (git count-objects -vH | awk '/size-pack/ {print $2 $3}')

    # unique contributors
    set contributors (git shortlog -sne | wc -l | string trim)

    echo "Files        : $file_count"
    echo "Tracked size : $human_size"
    echo "Commits      : $commit_count"
    echo "Pack size    : $pack_size"
    echo "Contributors : $contributors"
end
