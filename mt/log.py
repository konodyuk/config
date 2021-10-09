import logging

import click
import six
from pyinfra import logger

from mt.config import cfg

LOG_LEVELS = {
    0: logging.ERROR,
    1: logging.ERROR,
    2: logging.INFO,
    3: logging.DEBUG,
}


class LogHandler(logging.Handler):
    def emit(self, record):
        try:
            message = self.format(record)
            click.echo(message, err=True)
        except Exception:
            self.handleError(record)


class LogFormatter(logging.Formatter):
    def format(self, record):
        message = record.msg

        if record.args:
            message = record.msg % record.args

        if isinstance(message, six.string_types):
            if "-->" not in message:
                message = "    {0}".format(message)

            return message

        else:
            return super(LogFormatter, self).format(record)


def setup_logging(verbosity: int):
    cfg.verbosity = verbosity
    log_level = LOG_LEVELS[verbosity]
    logger.setLevel(log_level)
    if logger.hasHandlers():
        return
    handler = LogHandler()
    formatter = LogFormatter()
    handler.setFormatter(formatter)
    logger.addHandler(handler)
