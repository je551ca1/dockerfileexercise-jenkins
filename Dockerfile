# Use Python 3.6 or later as a base image
FROM python:3.9

# Copy contents into image
COPY . /app

# Set working directory
WORKDIR /app

# Install pip dependencies from requirements
RUN pip install -r requirements.txt

# Set YOUR_NAME environment variable
ENV YOUR_NAME=Jessica

# Expose the correct port
EXPOSE 5500

# Create an entrypoint
ENTRYPOINT ["python", "app.py"]
