import requests
from flask import Flask
from flask import request
from rich.console import Console

app = Flask(__name__)

@app.route("/api/users", method="POST")
def verify_user():
    data = request.data
    requests.post



class Server:
    def __init__(self, host="127.0.0.1", port="8814") -> None:
        self.console = Console()
        self.host = host
        self.port = port
    
    def start(self):
        self.console.print(f"starting server on {self.host}:{self.port}")
        app.run(host=self.host, port=self.port)

