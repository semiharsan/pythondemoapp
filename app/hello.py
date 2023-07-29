from flask import Flask

app = Flask(__name__)

@app.route("/")
def index():
    return "Congratulations !!! You just have published a demo python application on AWS ECS Service. Keep Working To Update Your Knowledge"

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=8000, debug=True)
