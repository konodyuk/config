from datetime import datetime, timedelta

from handler import handler

@handler.command(prefix="now", cut_prefix=True)
def now_handler(text, context):
    now = datetime.now()
    if len(text):
        if text.endswith("h"):
            delta = timedelta(hours=eval(text[:-1]))
        elif text.endswith("m"):
            delta = timedelta(minutes=eval(text[:-1]))
        else:
            delta = timedelta(minutes=eval(text))
        now += delta
    return now.strftime("%H:%M")

@handler.command(prefix="today", cut_prefix=True)
def today_handler(text, context):
    now = datetime.now()
    if len(text):
        delta = timedelta(days=eval(text))
        now += delta
    return now.strftime("%Y-%m-%d")
