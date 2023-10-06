FROM python:slim-buster

# Create a non-root user to run the application
RUN adduser --system appuser

# Declaring working directory in our container
WORKDIR /opt/apps

# Add pip scripts installation directory as a path environment
ENV PATH=$PATH:/home/appuser/.local/bin

# Copy the requirements file first to leverage Docker caching
COPY app/requirements.txt .

# Install the dependencies
RUN python3 -m pip install --upgrade pip && \
    python3 -m pip install -r requirements.txt

# Copy the rest of the application code
COPY app/ .

# Change the ownership of the working directory to the appuser
RUN chown -R appuser:appuser /opt/apps

# Switch to the non-root user
USER appuser

EXPOSE 8000

# Run the application
CMD [ "python3", "/opt/apps/hello.py" ]
