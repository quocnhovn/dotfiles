# Extract various archive formats
function extract --description "Extract various archive formats"
    if test (count $argv) -eq 0
        echo "Usage: extract <archive_file>"
        return 1
    end

    set file $argv[1]

    if not test -f $file
        echo "Error: '$file' not found"
        return 1
    end

    switch $file
        case '*.tar.bz2' '*.tbz2'
            tar xjf $file
        case '*.tar.gz' '*.tgz'
            tar xzf $file
        case '*.tar.xz' '*.txz'
            tar xJf $file
        case '*.tar'
            tar xf $file
        case '*.bz2'
            bunzip2 $file
        case '*.rar'
            unrar x $file
        case '*.gz'
            gunzip $file
        case '*.zip'
            unzip $file
        case '*.Z'
            uncompress $file
        case '*.7z'
            7z x $file
        case '*.xz'
            unxz $file
        case '*.exe'
            cabextract $file
        case '*'
            echo "Error: '$file' cannot be extracted via extract()"
            return 1
    end

    echo "✅ Extracted: $file"
end
