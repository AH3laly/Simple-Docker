#!/bin/bash
# Software Development and Deployment Script
#Created By github/AH3laly

APP_PATH=/opt/simple-docker

#Load Configuration
. $APP_PATH/simple-docker.conf

show-help(){
    clear
    echo
    echo Available commands:
    echo
    
    echo
    echo List Docker Images
    echo Syntax: img-list
    echo
    
    echo
    echo Build Docker Image
    echo Syntax: img-build [New_image_tag] [Path_to_Dockerfile]
    echo
    
    echo
    echo Remove Docker Image
    echo Syntax: img-remove [Image_Name or Image_ID]
    echo
    
    echo
    echo Pull Image from Docker Repo
    echo Syntax: img-pull [Docker_Repo_Image_Name]
    echo
    
    echo
    echo List Containers
    echo Syntax: con-list
    echo
    
    echo
    echo Create Container
    echo Syntax: con-create [New-Container-Name] [Image-Name or Image_ID]
    echo
    
    echo
    echo Display information about Container.
    echo Syntax: con-show [Container_name or Container_ID]
    echo
    
    echo
    echo Start Container
    echo Syntax: con-start [Container-Name or Container-ID]
    echo
    
    echo
    echo Open Container Bash
    echo Syntax: con-open [Container-Name or Container-ID]
    echo
    
    echo
    echo Stop Container
    echo Syntax: con-stop [Container-Name or Container-ID]
    echo
    
    echo
    echo Remove Container
    echo Syntax: con-remove [Container-Name or Container-ID]
    echo
    
    echo
    echo
    exit;
}

detect-apache-version(){
    apacheDaemonName=httpd
    apacheConfigPath=/etc/httpd/conf.d
    if [ -d "/etc/apache2" ]
    then
        apacheDaemonName=apache2
        apacheConfigPath=/etc/apache2/conf-enabled
    fi
}
pub-initialize(){
    #Make sure the default image is installed
    if [ $(docker images $default_docker_image | wc -l ) == 1 ]
    then
        echo
        echo Donwloading default image $default_docker_image :
        echo
        pub-img-pull $default_docker_image
    fi
}

###################### Images #########################################

pub-img-list(){
    docker images
}

pub-img-remove(){
    imageid=$1
    docker rmi -f $imageid
}

pub-img-build(){
    imagetag=$1
    dockerfile=$2
    docker build -t $defualt_docker_repo:$imagetag $dockerfile
}

pub-img-pull(){
    imagename=$1
    docker pull $imagename
}

###################### Container Commands #########################################

configure-container(){
    containername=$1
    ftp_port=$2
    #docker cp $APP_PATH/project_scripts/configure.sh $projectname:/scripts/
    #docker cp $APP_PATH/project_scripts/restart.sh $projectname:/scripts/
    docker cp $APP_PATH/container_scripts/. $containername:/simple-docker/
    docker exec -itd $containername mkdir /simple-docker
    docker exec -itd $containername chown root:root /simple-docker -R
    docker exec -itd $containername chmod 700 /simple-docker -R
    docker exec -itd $containername /simple-docker/configure.sh container_name=$containername ftp_port=$ftp_port
}
container-create-apache-proxy(){
    containername=$1
    #Set ProxyPass
    containerip=$(docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' $containername)
    echo "<Location '/$containername'>" > $apacheConfigPath/simple-docker-map-$containername.conf
    echo "ProxyPass 'http://$containerip'" >> $apacheConfigPath/simple-docker-map-$containername.conf
    echo "</Location>" >> $apacheConfigPath/simple-docker-map-$containername.conf
    systemctl restart $apacheDaemonName
}

container-remove-apache-proxy(){
    containername=$1
    rm $apacheConfigPath/simple-docker-map-$containername.conf
}

pub-con-show(){
    containername=$1
    echo
    echo Name: $containername
    echo IP Address: $(docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' $containername)
    echo
}

pub-con-create(){
    containername=$1
    imagename=$2
    
    if [ -z $1 ] || [ -z $2 ]
    then
        show-help
    fi
    
    #Increase Index
    echo $[$(cat $APP_PATH/core/index) + 1] > $APP_PATH/core/index
    containerindex=$(cat $APP_PATH/core/index)
    ftp_port=$[ 21000 + $containerindex ]
    #docker run -itd -p 21:21 -p 20:20 -p 5000-5999:5000-5999 --name $projectname --hostname $projectname.$domain_name $imagename /bin/bash
    docker run -itd -p $ftp_port:21 -p $[ 20000 + $containerindex ]:20 --name $containername --hostname $containername.$domain_name $imagename /bin/bash
    container-create-apache-proxy $containername
    configure-container $containername $ftp_port
    pub-con-open $containername
}

pub-con-start(){
    containername=$1
    docker start $containername
    docker exec -itd $containername /simple-docker/restart.sh
    container-create-apache-proxy $containername
}

pub-con-stop(){
    containername=$1
    docker stop $containername
    container-remove-apache-proxy $containername
}

pub-con-remove(){
    containername=$1
    pub-con-stop $containername
    docker rm $containername
    container-remove-apache-proxy
    systemctl restart $apacheDaemonName
}

pub-con-open(){
    containername=$1
    docker exec -i -t $containername /bin/bash
}

pub-con-list(){
    docker ps -a
}



################################# Start Up ####################################

detect-apache-version

if [ "$(type -t pub-$1)" != 'function' ]
then
    show-help
    exit;
fi

if [ "$2" == '--help' ]
then
    $1-help
    exit;
fi

pub-$1 $2 $3 $4 $5 $6 $7 $8 $9

