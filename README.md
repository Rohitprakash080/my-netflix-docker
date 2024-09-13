MY NETFLIX APP
12.09.2024


🔥OVERVIEW
The goal is to build an Nginx container, copy the contents of the netflix-clone directory into it, and run the container so you can access the application in a browser..

📌Directory Structure
Ensure your directory structure looks like this:

Here Dockerfile refers to the file where you will writing the code to create the image and netflix-clone is the directory where we have cloned the code of netflix.

📌Create the Dockerfile
Create a Dockerfile in the /path/to/project directory the mentioned content

📌Build the Docker Image
Got to project folder
Build image

📌Run the Docker Container

📌Access the Application
1️⃣Goto Vm network setting
Create inbound rule where allow the port of VM to connect to container port exposed in dockerfile (Like here 8080)

2️⃣Open a web browser and navigate to:
http://<publicip-of-vm>:8080




