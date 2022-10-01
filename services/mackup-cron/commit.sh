# set env
export PATH=/usr/local/bin:/usr/bin:/bin

# set logging
LOGDIR=$HOME/config/services/mackup-cron/logs
mkdir -p "$LOGDIR"
exec >>$LOGDIR/stdout.log
exec 2>>$LOGDIR/stderr.log

# enter config repo
cd $HOME/config

# get commit message prefix from timestamp
PREFIX="CRON ($(date +"%Y-%m-%d %H:%M:%S"))"

# log sync start
echo "SYNC $PREFIX"

# config repo: reset index and commit files
git reset

# mackup submodule: reset index and commit files
cd mackup
git reset
git add -A . && git commit -m "$PREFIX: update dotfiles"
git push
cd ..

# config repo: update submodule rev if necessary
git add mackup && git commit -m "$PREFIX: update mackup submodule revision"
git push
