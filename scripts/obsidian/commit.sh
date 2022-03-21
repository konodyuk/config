# set env
export PATH=/usr/local/bin:/usr/bin:/bin

# set logging
LOGDIR=$HOME/config/scripts/obsidian/logs
exec >>$LOGDIR/stdout.log
exec 2>>$LOGDIR/stderr.log

cd $HOME/Obsidian/main

PREFIX="CRON ($(date +"%Y-%m-%d %H:%M:%S"))"

echo "SYNC $PREFIX"

git reset
git add -A js && git commit -m "$PREFIX: js"
git add -A typed && git commit -m "$PREFIX: notes"
git add -A index INDEX.md && git commit -m "$PREFIX: indices"
git add typing.otl && git commit -m "$PREFIX: schema"
git add -A files && git commit -m "$PREFIX: files"

cd .obsidian
git reset
git add -A plugins && git commit -m "$PREFIX: update plugins"
git add -A themes && git commit -m "$PREFIX: update themes"
git add *.json && git commit -m "$PREFIX: update settings"
git push
cd ..

git add .obsidian && git commit -m "$PREFIX: update config submodule revision"
