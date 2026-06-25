from flask import Flask

app = Flask(__name__)

@app.route("/")
def home():
    return """
8Byte DevOps Assignment Running Successfully
what is your name? and what is your favorite place to visit?
"""

# @app.route("/health")
# def health():
#     return {"status":"healthy"}

if __name__ == "__main__":
    app.run(host="0.0.0.0",port=8080)