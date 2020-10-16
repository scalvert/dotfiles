
function compare-versions --description 'Compares versions using tag names. Specifically targetted at voyager-web'
 git log --pretty=oneline voyager-web_"$argv[1]"..voyager-web_"$argv[2]"       
end
