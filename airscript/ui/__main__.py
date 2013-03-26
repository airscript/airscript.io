import os

from eventlet import wsgi
import eventlet

from airscript.ui import app

if __name__ == "__main__":
    eventlet.monkey_patch()
    wsgi.server(eventlet.listen(
        ('', int(os.environ.get("PORT", 5000)))), app)
