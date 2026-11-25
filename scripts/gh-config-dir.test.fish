#!/usr/bin/env fish
# Tests the GH_CONFIG_DIR hook (conf.d/30-integrations.fish and config.fish).
# Each case starts a clean fish with a temporary HOME, so nothing under the
# real ~/.config is read or written.
#
# Run: fish scripts/gh-config-dir.test.fish

set -l pkg (realpath (status dirname)/../packages/fish)
# realpath: fish reports PWD with symlinks resolved, so HOME must match.
set -l tmp (realpath (mktemp -d))
set -g home $tmp/home
set -l fishdir $home/.config/fish

mkdir -p $fishdir/conf.d \
    $home/workspace/personal/x \
    $home/workspace/personal-backup \
    $home/workspace/other
cp $pkg/config.fish $fishdir/
cp $pkg/conf.d/30-integrations.fish $fishdir/conf.d/

set -g failures 0
# Resolve fish now: env -i clears PATH before it looks the command up.
set -g fish_bin (command -s fish)

# Start a login-free fish in $dir with the test HOME, run $cmd, print output.
# A minimal PATH keeps optional integrations (starship, mise, ...) out.
function run_in -a dir cmd
    cd $dir
    env -i HOME=$home XDG_CONFIG_HOME=$home/.config PATH=/usr/bin:/bin \
        $fish_bin -c $cmd
end

function check -a name want got
    if test "$got" = "$want"
        echo "ok   $name"
    else
        echo "FAIL $name: want '$want', got '$got'"
        set -g failures (math $failures + 1)
    end
end

set -l work $home/.config/gh-work
set -l custom $home/.config/gh-custom
set -l personal $home/.config/gh-scalvert
set -l show 'echo $GH_CONFIG_DIR'

# Default work directory when local.fish does not exist.
check "default work dir at startup" $work (run_in $home $show)

# A GH_WORK_CONFIG_DIR override in local.fish applies before the first cd.
echo "set -gx GH_WORK_CONFIG_DIR $custom" >$fishdir/local.fish
check "local.fish override at startup" $custom (run_in $home $show)
check "local.fish override in a work repo" $custom (run_in $home/workspace/other $show)

# Personal boundary: personal and anything below it, nothing that only
# shares the prefix.
check "personal root" $personal (run_in $home/workspace/personal $show)
check "personal subdir" $personal (run_in $home/workspace/personal/x $show)
check "personal-prefixed sibling" $custom (run_in $home/workspace/personal-backup $show)

# The PWD hook follows cd in both directions.
check "cd into personal" $personal \
    (run_in $home "cd $home/workspace/personal/x; $show")
check "cd to personal-prefixed sibling" $custom \
    (run_in $home/workspace/personal "cd $home/workspace/personal-backup; $show")

cd /
rm -rf $tmp

if test $failures -gt 0
    echo "$failures failed"
    exit 1
end
echo "all passed"
