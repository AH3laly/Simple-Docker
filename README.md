# Simple-Docker

**Simple-Docker** or **sDocker** is a Docker based management shell script to create, configure and manage Docker containers for Software Developers.

## Why to use Simple-Docker?

  - Simplify using docker to your team instead of asking all developers to get experienced in Docker commands.
  - Only single command will Create a ready to use container. 

## Requirements

  - Linux OS (At least Centos 7 or Ubuntu 16.04)
  - Apache server installed
  - Apache server mod_proxy enabled
  - Docker server installed.


## How to install?

```sh
git pull https://github.com/abd0m0hamed/Simple-Docker
cd Simple-Docker
sudo ./install.sh
```
## Available commands?

### List Docker images:
Display list of docker images.
```bash
sudo sdocker img-list
```
### Build Docker image:
Build docker image based on Dockerfile.
```sh
$ sudo sdocker img-build [PATH_TO_Dockerfile]
```
Live Example:
```sh
$ sudo sdocker img-build /opt/simple-docker/
```
> - Pass the location of **Dockerfile** as a parameter.
> - You can use the default Dockerfile in **/opt/simple-docker/**.

### Remove Docker image:
```sh
$ sudo sdocker img-remove [Image_name | Image_ID]
```
Live Example:
```sh
$ sudo sdocker img-build dev-webserver /opt/simple-docker/
```
> - You can pass the **Image Name** or **Image ID** as a parameter.
> - Use sdocker `img-list` command to get **Image Name** and **Image ID**.

### Pull Docker image:
```sh
$ sudo sdocker img-pull centos
```

### List Docker containers:
Display a list of Docker containers.
```sh
$ sudo sdocker con-list
```

### Create Docker container:
```sh
$ sudo sdocker con-create [container-name] [image-name | image-id]
```
Live Example:
```sh
$ sudo sdocker con-create container1 b9d1b78aceab
```
>**Notes:**
> - You can use Docker **image-name** or **image-id**
> - **[container-name]** valid characters are:  **A-Z** or **a-z** or **_** or **-**
> - Use `img-list` command to get **Image Name** or **Image ID**
> - Use `con-list` command to view a list of containers.

> **What procedures exactly executed in the background when you run con-create?:**
> - Execute the native `docker run` command to create docker container.
> - Map custom FTP port **21xxx** to container port 21, So you can connect to the container using FTP protocol using: **[host_ip_address]:21xxx**
> - Create Apache proxy handler to map **[host_ip_address]/container_name** to container's port **80**.
> Ex: **http://host-server/container1** mapped to **http://container_ip:80**
> - Copy all files from **/opt/simple-docker/container_scripts/** on host to **created_container:/simple-docker/**
> - Execute the script **/simple-docker/configure.sh** inside the container.

> **Notes:**
> - All files placed in **/opt/simple-docker/container_scripts/** , Will be coppied automatically to **/simple-docker/** on all new containers.
> - To run your custom scripts automatically inside the container after creation, Place your commands in **/opt/simple-docker/container_scripts/custom_scripts.sh** or include your script at end of file:
```sh
vim /opt/simple-docker/container_scripts/custom_scripts.sh
. /simple-docker/my_custom_script.sh
```

> **`Note:`** `All scripts you place in ` **`/opt/simple-docker/container_scripts`** ` directory will be executed in-side the Container not the host.`

### Start Docker container:
Start Docker container.
```sh
$ sudo sdocker con-start [container-name | container-id] 
```
Live Example:
```sh
$ sudo sdocker con-start container1
```
### Stop Docker container:
```sh
$ sudo sdocker con-stop [container-name | container-id] 
```
Live Example:
```sh
$ sudo sdocker con-stop container1
```
> Stop Docker container after finishing your work to save the Host server resources.

### Access Docker container:
Moves you into the container bash.
```sh
$ sudo sdocker con-open [container-name | container-id] 
```
Live Example:
```sh
$ sudo sdocker con-open container1
```
>The container must be running, If not, Start it Using `con-start` command.

### Exit Docker container:
Exit from Docker container bash
```sh
$ exit
```
> Don't forget to stop the container after finish working on it to save resources.
> User `con-stop` command to stop the container.

### Show Docker container info:
Display information about a specific container.
```sh
$ sudo sdocker con-show [container-name | container-id] 
```
Live Example:
```sh
$ sudo sdocker con-show container1
```

### Remove Docker container:
```sh
$ sudo sdocker con-remove [container-name | container-id] 
```
Live Example:
```sh
$ sudo sdocker con-remove container1
```
**`WARNING:`** `This is a distructive command, You will permanently remove the Docker container.`
