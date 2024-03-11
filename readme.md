## Web Front-End (Requirements)
Create a simple web frontend app that displays the hostname of the server it’s running on and a version number on a web UI. (ie ‘node-01’, version 1.0). 


## Deployement using Elastic Container Service (ECS) - Requirement
- Dockerize the above app and host in Amazon ECS
- Use a load balancer to distribute requests among 2 or more containers.
- Use ECS Service to manage task deployment.
- This should all be done as Infrastructure-as-code (choose from Terrafrom, Cloudformation, AWS SDK/CDKs)

## Prerequisite
- node 
- terraform
- aws cli  
- docker

## QuickStart

1. Clone this repository
    ```bash
    git clone https://github.com/Oyoh-Edmond/simpleNodejsApp-ECS.git
    ```
2. Initial npm and install packages 
    ```bash
    npm init
    npm install
    ```
3. Run application
    ```bash
    npm start
    ```