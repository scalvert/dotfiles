function manpdf --description 'Open man page as PDF in Preview'
    man -t $argv[1] | open -f -a /Applications/Preview.app/
end
