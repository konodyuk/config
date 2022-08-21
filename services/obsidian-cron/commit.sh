# set env
export PATH=/usr/local/bin:/usr/bin:/bin

# set logging
LOGDIR=$HOME/config/services/obsidian-cron/logs
exec >>$LOGDIR/stdout.log
exec 2>>$LOGDIR/stderr.log

# enter vault
cd $HOME/Obsidian/main

# get commit message prefix from timestamp
PREFIX="CRON ($(date +"%Y-%m-%d %H:%M:%S"))"

# log sync start
echo "SYNC $PREFIX"

# content repo: reset index and commit files
git reset
git add -A js && git commit -m "$PREFIX: js"
git add -A typed && git commit -m "$PREFIX: notes"
git add -A index INDEX.md && git commit -m "$PREFIX: indices"
git add typing.otl && git commit -m "$PREFIX: schema"
git add -A files && git commit -m "$PREFIX: files"

# config submodule: reset index and commit files
cd .obsidian
git reset
git add -A plugins && git commit -m "$PREFIX: update plugins"
git add -A themes && git commit -m "$PREFIX: update themes"
git add *.json && git commit -m "$PREFIX: update settings"
git push
cd ..

# content repo: update submodule rev if necessary
git add .obsidian && git commit -m "$PREFIX: update config submodule revision"
