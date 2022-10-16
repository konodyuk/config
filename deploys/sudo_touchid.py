from pyinfra.operations import server

server.shell("sh -c 'curl -sL git.io/sudo-touchid | sh'", _sudo=True)
