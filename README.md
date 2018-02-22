# SSHD

Build a OPEN-SSH server using Dockerfile. The server runs on a CENTOS:7 base image and installs the necessary tools.

The server is configured by my default SSH_CONFIG file to only allow SFTP entry. Furthermore, my SSH_CONFIG chroots the testUser and confines the user to only their respective $HOME directory.

## Getting Started

These instructions will get you a copy of the project up and running on your local machine for development and testing purposes. See deployment for notes on how to deploy the project on a live system.

### Prerequisites

What things you need to install the software and how to install them

1. Have a DockerHub account and login via CLI -> allows you to push and pull images you build
2. On the CLI, enter these commands:
```
docker build -t <$name:version> .
```
3. 
```
docker push <$name:version>
```
4. Now your SSH server image should be on DockerHub, linked to your own account.
4. Install minikube: https://github.com/kubernetes/minikube
5. Install helm: https://github.com/kubernetes/helm
6. 
```
minikube start --vm-driver=xhyve
```
7.
```
helm init
```
8. Install a SFTP service: https://filezilla-project.org/

### Installing

Now that the environment is set up, follow these instructions to get the SSH server up and running:

1. Add your own PUBLIC SSH_KEY into the environment variable in the deployment.yaml chart. This will authenticate you as the SFTP User.
1. 
```
helm install --name ssh-server sftp-chart
```
2. If this runs successfully, then you will see instructions printed in terminal.
3. 
```
kubectl get po
```
4. Copy that $POD_ID and:
```
kubectl port-forward $POD_ID 8080:22
```

## Running the tests

1. Open filezilla and connect to localhost:8080 as testUser and your own PRIVATE SSH_KEY file location (RSA)
2. If successful, you now have the permissions to modify that SFTP directory using a password-less entry.

