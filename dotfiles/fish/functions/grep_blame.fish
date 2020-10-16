function grep_blame
    git grep -n $argv | perl -F':' -anpe '$_=`git blame -f --date=short -L$F[1],+1 $F[0]`' | tr -d '()' | awk '{n=$3"_"$4;print $1,$2,$6,n;}'
end
