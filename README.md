We will deploy a simple python app on kubernetes cluster which is installed on Linux Server virtual machine. 

1. Create a hello.py file 

nano hello.py
#====================START==========================================#
from flask import Flask

app = Flask(__name__)

@app.route("/")
def index():
    return "Congratulations, Hello World"

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=8000, debug=True)
#====================END==========================================#

2. Create a Dockerfile

nano Dockerfile
#====================START==========================================#
FROM python:slim-buster

#= Declaring working directory in our container and change user
WORKDIR /opt/apps

#Add a new user and change to that for python security consideration
RUN adduser appuser && chown -R appuser /opt/apps
USER appuser

#= Add pip scripts installation directory as path environment
ENV PATH=$PATH:/home/appuser/.local/bin

#= As optional you can upgrade pip script to latest version.
RUN python3 -m pip install --upgrade pip

#= Copy all relevant files to our working dir /opt/apps
COPY app/. .

#= If you need you can install all requirements for our app with requirements.txt file
RUN python3 -m pip install -r requirements.txt

EXPOSE 8000

#= Run the application
CMD [ "python3", "/opt/apps/hello.py" ]
#====================END==========================================#

3. Create hellopython.yml file and change "WriteHereYourDockerhubAccount" with your own docker hub account

nano hellopython.yml
#====================START==========================================#
apiVersion: apps/v1
kind: Deployment
metadata:
  name: hellopython
spec:
  selector:
    matchLabels:
      app: hellopython
  replicas: 2 # tells deployment to run 2 pods matching the template
  strategy:
    type: RollingUpdate
    rollingUpdate:
      maxSurge: 1
      maxUnavailable: 1

  template:
    metadata:
      labels:
        app: hellopython
    spec:
      containers:
      - name: hellopython
        image: WriteHereYourDockerhubAccount/hellopython:v1
        imagePullPolicy: Always
        ports:
        - containerPort: 8000
---
apiVersion: v1
kind: Service
metadata:
  name: hellopython-service
  labels:
    app: hellopython
spec:
  selector:
    app: hellopython
  type: LoadBalancer
  ports:
    - port: 8000
      targetPort: 8000
      nodePort: 31700
#====================END==========================================#

4. Create requirements.txt file for python pip module

nano requirements.txt
#= requirements.txt file
#====================START==========================================#
Flask==1.1.2
#====================END==========================================#

5. Create shell script to create docker image and kubernetes deployments automatically

#Login docker hub with your account credentials before you run script
docker login 

nano hellopython-shell.sh
#= Please change "WriteHereYourDockerhubAccount" with your own docker hub account in hellopython-shell.sh file
#====================START==========================================#
#!/bin/bash
mkdir ~/hellopyhton
cp * ~/hellopyhton
cd ~/hellopyhton
mkdir app
cp hello.py requirements.txt app
docker build -t hellopython .
docker tag hellopython WriteHereYourDockerhubAccount/hellopython:v1
docker push WriteHereYourDockerhubAccount/hellopython:v1
kubectl apply -f hellopython.yml
#====================END==========================================#

6. Change script to executable file.

chmod u+x hellopython-shell.sh

7. Remove the spurious CR characters inside the file to make it run commands properly via shell.

sed -i -e 's/\r$//' hellopython-shell.sh

8. Run the script to deploy your application

./hellopython-shell.sh

I hope all these scripts it works for your requirements.
