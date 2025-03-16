import os
from flask import Flask,request

app=Flask(__name__)

@app.route("/")
def home():
    print(f'User-Agent: {request.headers.get("User-Agent")}')
    return f'Hello {os.environ.get("USER", "World")}'

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=3000)
