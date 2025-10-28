# Fish abbreviations for quick access
# Based on best practices from dotfiles-docs.vercel.app

# Git abbreviations
abbr -a g git
abbr -a gs git status
abbr -a ga git add
abbr -a gc git commit
abbr -a gcm git commit -m
abbr -a gco git checkout
abbr -a gb git branch
abbr -a gp git push
abbr -a gpl git pull
abbr -a gd git diff
abbr -a gl git log --oneline
abbr -a gss git stash save
abbr -a gsp git stash pop

# Laravel/PHP abbreviations
abbr -a art php artisan
abbr -a artisan php artisan
abbr -a composer-dev composer install --dev
abbr -a composer-prod composer install --no-dev --optimize-autoloader
abbr -a phpunit ./vendor/bin/phpunit
abbr -a pest ./vendor/bin/pest

# Go abbreviations
abbr -a gor go run
abbr -a gob go build
abbr -a got go test
abbr -a gom go mod
abbr -a gomi go mod init
abbr -a gomt go mod tidy
abbr -a gog go get

# Docker abbreviations
abbr -a d docker
abbr -a dc docker-compose
abbr -a dcu docker-compose up
abbr -a dcd docker-compose down
abbr -a dcb docker-compose build
abbr -a dcl docker-compose logs
abbr -a dce docker-compose exec
abbr -a dps docker ps
abbr -a di docker images
abbr -a dv docker volume ls
abbr -a dn docker network ls

# System abbreviations
abbr -a ll exa -la --icons
abbr -a la exa -a --icons
abbr -a lt exa --tree --icons
abbr -a update sudo apt update && sudo apt upgrade
abbr -a install sudo apt install
abbr -a remove sudo apt remove
abbr -a search apt search
abbr -a clean sudo apt autoremove && sudo apt autoclean

# Navigation abbreviations
abbr -a .. cd ..
abbr -a ... cd ../..
abbr -a .... cd ../../..
abbr -a ~ cd ~
abbr -a dev cd ~/Development
abbr -a proj cd ~/Development/Projects
abbr -a dot cd ~/Development/OS/dotfiles

# File operations
abbr -a c clear
abbr -a h history
abbr -a j jobs
abbr -a v nvim
abbr -a vim nvim
abbr -a cat bat
abbr -a find fd
abbr -a grep rg

# Network abbreviations
abbr -a wget wget -c
abbr -a curl-json curl -H "Content-Type: application/json"
abbr -a myip curl ifconfig.me
abbr -a speedtest curl -s https://raw.githubusercontent.com/sivel/speedtest-cli/master/speedtest.py | python3 -

# Process abbreviations
abbr -a ps ps aux
abbr -a psg ps aux | grep
abbr -a kill killall
abbr -a top htop

# Archive abbreviations
abbr -a tgz tar -czf
abbr -a untgz tar -xzf
abbr -a tbz tar -cjf
abbr -a untbz tar -xjf

# Development server abbreviations
abbr -a serve python3 -m http.server
abbr -a artserve php artisan serve
abbr -a npmdev npm run dev
abbr -a npmbuild npm run build
abbr -a npmstart npm start

# Update and maintenance abbreviations
abbr -a update-all ~/Development/OS/dotfiles/update.sh
abbr -a quick-update ~/Development/OS/dotfiles/quick-update.sh
abbr -a system-update sudo apt update && sudo apt upgrade -y
abbr -a dotfiles-update cd ~/Development/OS/dotfiles && git pull && ./update.sh
abbr -a topgrade-update topgrade --yes
