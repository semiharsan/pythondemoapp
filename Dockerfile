FROM python:slim-buster

# Declaring working directory in our container and change user
WORKDIR /opt/apps

#Add a new user and change to that for python security consideration
RUN adduser appuser && chown -R appuser /opt/apps
USER appuser

# Add pip scripts installation directory as path environment
ENV PATH=$PATH:/home/appuser/.local/bin

# As optional you can upgrade pip script to latest version.
RUN python3 -m pip install --upgrade pip

# Copy all relevant files to our working dir /opt/apps
COPY app/. .

# If you need you can install all requirements for our app with requirements.txt file
RUN python3 -m pip install -r requirements.txt
USER root
RUN apt-get update && apt-get install -y curl net-tools telnet

EXPOSE 8000

# Run the application
CMD [ "python3", "/opt/apps/hello.py" ]
