## JMDCCommander
To host the Dockefile for a container with ROOT, compiler, emacs, svn, ..., so that you can compile and use JMDCCommander

The code on GitHub (https://github.com/bozzochet/DockerJMDCCommander) is then connected to DockerHub (https://github.com/bozzochet/jmdccommander). The idea is to take the Docker image and run directly from DockerHub without looking at the GitHub code.

The Docker will be built starting from the ufficial ROOT Docker: https://hub.docker.com/r/rootproject/root and the README of that DockerHub image is quite helpful (part of it is replicated here).

### Supported tags
* latest

### Supported C++ standards
Tag 'latest' (the default tag) comes with ROOT compiled with C++11 support.

### To build (if taking the image from DockerHub you **don't need** to do this):
```
$ docker build --tag bozzochet/jmdccommander:latest .
```

### To run the container:
[adapted from https://hub.docker.com/r/rootproject/root]

In order to run containers, you must have Docker installed and, once, you need to execute
```
docker pull bozzochet/jmdccommander
```
Then you can start a container by running the following command in your terminal which will start the latest stable release of ROOT:
```
docker run --rm -it bozzochet/jmdccommander:latest
```
Note that the `--rm` flag tells Docker to remove the container, together with its data, once it is shut down. In order to persist data, it is recommended to mount a directory on the container. The idea is to have a "working dir" where to work and, in particular, run the container. This directory can contain all the files you need when you'll be inside the container and then will host few small (hidden) files to have the persistence of the bash and ROOT history and any "output" file you create inside the container and you want to keep afterwards.

On Linux and Mac, run:
```
docker run --rm -it -v `pwd`:/home/studente/current_dir bozzochet/jmdccommander:latest
```
The `-v` option tells Docker to mount the home directory (`~`) to `/userhome` in the container. ~~`--user $(id -u)` signs us in with the same userid as in the host in order to allow reading/writing to the mounted directory. This is not necessary on Windows. Mac and Windows users does however have to mark the drives or areas they want to mount as shared in the Docker application under settings.~~

To use the host network as it is:
```
docker run --net=host --rm -it bozzochet/jmdccommander:latest
```

To enter the container as root (there's no sudo for the default user, so no package installing allowed):
```
docker run --user root --rm -it bozzochet/jmdccommander:latest
```

**The suggested way of running, to allow also the creation of the lxplus ssh socket, is**:
```
docker run --net=host --user root --rm -it -v `pwd`:/home/testsys/current_dir bozzochet/jmdccommander:latest
```

### Enabling graphics

##### Linux
To use graphics, make sure you are in an X11 session and run the following command:

```
docker run -e DISPLAY=$DISPLAY -v /tmp/.X11-unix:/tmp/.X11-unix --rm -it --user $(id -u) bozzochet/jmdccommander:latest
```

On some platforms (e.g., Arch Linux) connections to the X server must be allowed explicitly by executing `xhost local:root` or an equivalent command (see e.g. [this page](https://wiki.archlinux.org/index.php/Xhost) for more information on `xhost` and its possible security implications).

##### OSX
To use graphics on OSX, make sure [XQuarz](https://www.xquartz.org/) is installed. After installing, open XQuartz, and go to XQuartz, Preferences, select the Security tab, and tick the box "Allow connections from network clients". Then exit XQuarz. Afterwards, open a terminal and run the following commands: `ip=$(ifconfig en0 | grep inet | awk '$1=="inet" {print $2}')`
This will grab your IP address on the local network. Run `echo $ip` to make sure it was successfull. If nothing is displayed, replace `en0` with `en1` or a higher number in the command.
Then is enough to run `xhost + $ip` and this will start XQuartz and whitelist your local IP address. Finally, you can start up ROOT with the following command:
```
docker run --rm -it -v /tmp/.X11-unix:/tmp/.X11-unix -e DISPLAY=$ip:0 bozzochet/jmdccommander:latest
```

## Examples (OSX as "host")
##### Bash session:
```
docker run --rm -it -v /tmp/.X11-unix:/tmp/.X11-unix -v `pwd`:/home/studente/current_dir -e DISPLAY=`ifconfig en0 | grep inet | awk '$1=="inet" {print $2}'`:0 bozzochet/jmdccommander:latest /bin/bash
```
will
  - export the display;
  - export the current dir (i.e. `pwd`) to the container 'current_dir' inside the user (i.e. 'studente') home. This is quite useful and makes the bash and ROOT history persistent;
  - open a bash session.
  
##### ROOT CINT (batch mode, no graphics):
```
docker run --rm -it -v /tmp/.X11-unix:/tmp/.X11-unix -v `pwd`:/home/studente/current_dir -e DISPLAY=`ifconfig en0 | grep inet | awk '$1=="inet" {print $2}'`:0 bozzochet/jmdccommander:latest
```
will
  - export the display;
  - export the current dir (i.e. `pwd`) to the container 'current_dir' inside the user (i.e. 'studente') home. This is quite useful and makes the bash and ROOT history persistent;
  - open ROOT CINT in batch mode (i.e. `root -b`).

##### ROOT CINT (graphics enabled)
```
docker run --rm -it -v /tmp/.X11-unix:/tmp/.X11-unix -v `pwd`:/home/studente/current_dir -e DISPLAY=`ifconfig en0 | grep inet | awk '$1=="inet" {print $2}'`:0 bozzochet/jmdccommander:latest root
```
will
  - export the display;
  - export the current dir (i.e. `pwd`) to the container 'current_dir' inside the user (i.e. 'studente') home. This is quite useful and makes the bash and ROOT history persistent;
  - open ROOT CINT (graphics enabled, i.e. `root` command)

##### ROOT CINT macro execution (graphics enabled)
```
docker run --rm -it -v /tmp/.X11-unix:/tmp/.X11-unix -v `pwd`:/home/studente/current_dir -e DISPLAY=`ifconfig en0 | grep inet | awk '$1=="inet" {print $2}'`:0 bozzochet/jmdccommander:latest root macro.C
```
will
  - export the display;
  - export the current dir (i.e. `pwd`) to the container 'current_dir' inside the user (i.e. 'studente') home. This is quite useful and makes the bash and ROOT history persistent. Here is permitting to 'call' a (local) macro file (`macro.C` in this example) and find it also inside the container; 
  - open ROOT CINT (graphics enabled, i.e. `root` command);
  - run the macro `macro.C`

## Examples of different containers
[See GitHub for example Dockerfiles.](https://github.com/root-project/docker-examples)
