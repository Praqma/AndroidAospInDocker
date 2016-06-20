# How to build Android aosp in Docker container
----
## Build Android 6.0 *Marshmallow*
### Description 

This is a setup for building Android Marshmallow, branch: android-6.0.1\_r40, for Nexus9: aosp_flo-userdebug. It requires openjdk-7. The setup supposed to be run by **root** user. 

If you want to build master branch It requires openjdk-8. TBD instruction how to change Dockerfile with new version of java and new user 

### Requirements
This setup has been tested on AWS EC2 instance c4.4xlarge 30 Gb RAM, 16VCPU 62ECU 320 Gb SSD. OS Ubuntu Trusty 14.04 LTS, kernel version: 3.13.0-77-generic. Docker version: 1.11.2. Docker compose version: 1.7.1
In this documantation it supposed you have a host or AWS instance with docker v1.11.2 and docker-compose v1.7.1 are installed. See [Install Docker on Ubuntu](https://docs.docker.com/engine/installation/linux/ubuntulinux/)

See [Build Environment](https://source.android.com/source/requirements.html#hardware-requirements) to know more about minimum HW requirements. 


### Preparations 
1. Download Android sources. To save a build time this setup supposed to map sources dir as a volume disk. You will do it once and be able reuse the same sources for many containers.

 Install Repo tool:
 
 ```
 mkdir ~/bin
 PATH=~/bin:$PATH
 curl https://storage.googleapis.com/git-repo-downloads/repo > ~/bin/repo
 chmod a+x ~/bin/repo
 # Repo is a python script, so
 apt-get install python
```

 Make a directory download the sources to.
 Go to this directory and set git global configuration:

```
 git config --global user.name "Your Name"
 git config --global user.email "you@example.com"
 mdkir ~/source
 cd ~/source
 # -b android-6.0.1_r40 is to checkout sources for Nexus 9
 repo init -u https://android.googlesource.com/platform/manifest -b android-6.0.1_r40
 repo sync
```
  
See [Installing Repo and Download sources](https://source.android.com/source/downloading.html#installing-repo) for more details

2. Clone this project:
    
```
cd ~/
git clone https://github.com/Praqma/AndroidAospInDocker.git
```

3. Make two more directories: one for ccache and one to set build output from the repo directory

```
mkdir ~/ccache
mkdir ~/build
```

4. Change the docker-compose file with new paths:
Set the paths to source directory, ccache and build output directories on the host.   

### The build time!
Go to the docker git repo you dowloaded and run:

```
cd ~/AndroidAospInDocker
docker-compose up -d --build
```

For the first time build can take 1h or more. After that you will be able to use ccache and build will take about 25min.
TBD: map additional RAM disk

You can follow by the building log using:

```
docker logs -f <ContainerID>
```
 
After the build finishes you will find image in the build directory you redirected the output.

## Known problems

#### Parallel jobs execution

For reasons we are still investigating, 'make' build in docker container can not support more then 3 parallel jobs. It leads to defunct java processes those can not be killed any other way then reboot the host. There are a few reference on the problems with java in docker could be connected with this particular problem.

 
