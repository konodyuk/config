# setup cron, TODO: check if on the main machine
from pyinfra.operations import brew, server

brew.packages(
    name="Install obsidian",
    packages=["obsidian"],
)

server.crontab(
    name="Obsidian crontab",
    command="$HOME/config/services/obsidian-cron/commit.sh",
    minute="*/30",
    cron_name="obsidian-cron",
)
