from flask import Flask

app = Flask(__name__)

@app.route("/")
def index():
    return "Congratulations !!! You just have published python application to on-premise Kubernetes Cluster. Now go to nezt step to install nginx for certificate and external network access"

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=8000, debug=True)
