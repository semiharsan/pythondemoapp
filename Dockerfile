FROM python:slim-buster

# Declaring working directory in our container and change user
WORKDIR /opt/apps

#Add a new user and change to that for python security consideration
RUN adduser appuser && chown -R appuser /opt/apps
USER appuser

# Copy all relevant files to our working dir /opt/apps
COPY app/. .

# If you need you can install all requirements for our app with requirements.txt file
RUN python3 -m pip install -r requirements.txt

# Add pip scripts installation directory as path environment
RUN export PATH="$HOME/appuser/.local/bin:$PATH"

# As optional you can upgrade pip script to latest version.
RUN python3 -m pip install --upgrade pip

EXPOSE 8000

# Run the application
CMD [ "python3", "/opt/apps/hello.py" ]
