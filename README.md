# Fabric Images

This repository contains the IBM-signed Docker images and Docker Compose files for running Hyperledger fabric code.  These images have been tested for functionality, stability and performance across the available platforms, and a dedicated support team within IBM is available to help resolve code defects or configuration issues for networks running supported configurations against Hyperledger fabric code.  Visit the [IBM Blockchain Support](http://www.ibm.com/blockchain/contact-expert.html) page for more information on obtaining support for your local network.

## Disclaimer

The architecture behind IBM Blockchain is the Linux Foundation's Hyperledger Project. Hyperledger fabric is an open source project under active development, currently in *Incubation* status. Each code contribution from the open source community makes Hyperledger fabric more robust, but can present adoption challenges. During the *Incubation* cycle, clients can use Hyperledger fabric for network testing and simulation. IBM does offer support for blockchain networks running on signed Docker images, but cautions against running financial assets of value directly on a Hyperledger fabric v0.6 blockchain network.

## Using your Docker images

These images provide you with a self-contained local blockchain environment running on Hyperledger fabric v0.6 code.  There are two configurations available: 1) a single node + CA (certificate authority) network; and 2) a four node + CA network.  The images and configurations have been tested and verified by IBM development, and should not be altered.  IBM offers support for both configurations.  Please see the **Getting Support** section at the bottom of the page for more information.  

## Platform

The images for the membership services (CA) and peer have been built for the Intel (x86), Power (ppc64le), and LinuxONE or z Systems (s390x) platforms

## Supported configurations

The default configurations for each network (single node and four node) have been tested and verified by IBM for stability and functionality.  Altering the the number of containers in the network is not supported (e.g. 10 peers and 1 CA is not a supported configuration).

## Prerequisites

Ensure that you have Docker for [Mac](https://docs.docker.com/engine/installation/mac/),  [Windows](https://docs.docker.com/engine/installation/windows/) or [Linux](https://docs.docker.com/engine/installation/#/on-linux) 1.12 or higher properly installed on your machine.  You must also have [Docker Compose](https://docs.docker.com/compose/install/) 1.7 or higher installed.

If you are running on Power and want to install the Docker prerequisites from your terminal:
```
apt-get install docker.io
```
then
```
pip install docker-compose
```

You do not need a vagrant environment in order to run your Docker images.  The images will function on Windows, Linux, and Mac, assuming that the prerequisite Docker versions have been properly installed.  However, if you choose to run your Docker containers within vagrant and need to upgrade your Docker Compose version:


1. Login to root in vagrant
2. Ensure you have the [cURL](https://curl.haxx.se/download.html) tool installed.  Then:

```
curl -L "https://github.com/docker/compose/releases/download/1.8.0/docker-compose-$(uname -s)-$(uname -m)" > /usr/local/bin/docker-compose
```
3. Make the file an executable:

```
chmod +x /usr/local/bin/docker-compose
```
4. Check version:

```
docker-compose version
```

## Docker Toolbox

If you are running any version of Windows that is not Windows 10, there is no native support for Docker. In this case you must install [Docker Toolbox](https://www.docker.com/products/docker-toolbox). The Docker Toolbox is an installer to quickly and easily install and setup a Docker environment on your computer.  Docker Toolbox installs a VirtualBox on your machine with Docker 1.12 and Docker Compose in a "default" VM. You will not see the VM until you start the VirtualBox. You can run all Docker commands and Docker Compose commands from the toolbox as if you were running them on the command line. Once you are in the toolbox, it is the same experience as if you were running on a Linux machine with Docker & Docker Compose installed.

Start up the default Docker host by clicking on the Docker Quickstart Terminal. It will open a new terminal window and initialize the Docker host. Once the startup process is complete, you will see the Docker whale together with the IP address of the Docker host, as shown below. In this example the IP address of the Docker host is 192.168.99.100. Take note of this IP address as you will need it later to connect to your Docker containers.

If you need to retrieve an IP address for one of your peers, use the `docker inspect` command as described in the Helpful Docker Commands section at the bottom of this page.

```
                        ##         .
                  ## ## ##        ==
               ## ## ## ## ##    ===
        /"""""""""""""""""\___/ ===
   ~~~ {~~ ~~~~ ~~~ ~~~~ ~~~ ~ /  ===- ~~~
        \______ o           __/
         \    \         __/
          \____\_______/

docker is configured to use the default machine with IP 192.168.99.100
For help getting started, check out the docs at https://docs.docker.com
```

## Pulling the images

[Docker Compose](https://docs.docker.com/compose/) will be used to run the images and spin up your local environment.  By using Docker Compose, you don't need to execute a `docker pull` command to retrieve the images.  The images are specified in the docker-compose.yml file and will download automatically when you ultimately execute the `docker-compose` command.

## Getting started and using Docker Compose

1. The Docker Compose files and configurations are located in GitHub.  If you do not have Git installed, download the appropriate [Git client](https://git-scm.com/downloads) for your OS.  Now clone the repository:

```
git clone https://github.com/IBM-Blockchain/fabric-images.git
```
2. Go into the docker-compose directory:

```
cd fabric-images/docker-compose
```
3. Set the environment by executing the setenv.sh script:

```
. setenv.sh
```
4. If you wish to configure your network by changing environment variables or customizing port mapping, skip below to the __Configuration Considerations__ section.  If you want to run with the default settings, proceed to the next step.

5. Run one of the two docker compose files, single-peer-ca.yaml or four-peer-ca.yaml.  For example:

```
docker-compose -f four-peer-ca.yaml up
```  

## Configuration considerations

You have the ability to change configuration parameters associated with the peers and membership services by editing the yaml files located in the `base ` directory.  For instance, to edit the peer yaml file:
```
cd fabric-imgages/docker-compose/base
vi peer-secure-base.yaml
```
Though not recommended, you could customize your network by changing environment variables or implementing port mapping.  See the fabric [core.yaml](https://github.com/hyperledger/fabric/blob/master/peer/core.yaml) and [membersvc.yaml](https://github.com/hyperledger/fabric/blob/v0.6/membersrvc/membersrvc.yaml) files to understand the environment variables.  For example, you could choose to disable security by setting `CORE_SECURITY_ENABLED=false`.  

Networking is also customizable, with the default port mappings shown below.  If this configuration does not work due to conflicts with existing listeners or firewalls, please modify accordingly.  The port mapping allows for the client to be local or remote, and connect to the fabric by accessing an IP address on this host with the appropriate port.

View the following configuration for vp0 and vp1 to see the preset port mappings:
```yml
vp0:
  image: hyperledger/fabric-peer:x86_64-0.6.0-preview
  extends:
    file: base/peer-secure-pbft-base.yaml
    service: peer-secure-pbft-base
  ports:
    - "7050:7050"
    - "7051:7051"
    - "7053:7053"  

vp1:
  image: hyperledger/fabric-peer:x86_64-0.6.0-preview
  extends:
    file: base/peer-secure-pbft-base.yaml
    service: peer-secure-pbft-base
  ports:
    - "8050:7050"
    - "8051:7051"
    - "8053:7053"
```
Therefore, to issue a chaincode REST call to vp1 on a host with an IP address of 1.1.1.1, you would submit the API to `http://1.1.1.1:8050/chaincode`, because 7050 is the default REST port and it has been mapped to 8050 on vp1.

## Additional details for Docker Compose

Make sure you are in the same directory where your docker-compose.yaml file resides.  For a single node + CA network:
```
docker-compose -f single-peer-ca.yaml up
```
For a four node + CA network:
```
docker-compose -f four-peer-ca.yaml up
```
To run docker containers in "detached" mode:
```
docker-compose -f <composefile> up -d
```

This will take a few minutes the first time this command is issued; the images have to be downloaded and extracted onto your local machine.

## Getting started with chaincode

You have the option of either deploying sample chaincode to your blockchain network, or developing your own original code.  If you are interested in developing some organic Go code, use the IBM-Blockchain [learn chaincode](https://github.com/IBM-Blockchain/learn-chaincode) repository as a starting point.  This repo will teach you the major chaincode functions, and then guide you through the construction and implementation of a simple piece of Go code.  Once constructed, you will compile your code, deploy it to a blockchain network, and then issue invocation transactions.  If you are already familiar with the basic tenets of Hyperledger fabric and chaincode, then proceed to the next section.  

## Hyperledger fabric v0.6 release notes

There are new features available and several programming changes have been implemented during the migration from the Hyperledger fabric v0.5-developer-preview codebase to v0.6.  You will need to update your code accordingly in order for your chaincode to properly function against a v0.6 Hyperledger fabric network.  See the [migration notes](https://github.com/IBM-Blockchain/fabric-images/blob/master/v0.6_migration.md) for more details on the programming changes.    

## Testing and verifying your local network

* Check that the Docker containers have successfully started.  This will show you your active containers:
```
docker ps
```
*Assuming you have no other Docker processes running*, you should see two active containers for the single node configuration, and five active containers for the four node configuration.

* To ensure that your network is functioning as expected, deploy a piece of chaincode and issue a subsequent invoke transaction, followed by a query.  You can do this with a REST call through an external API client,  such as Postman or SOAP UI, through the CLI, through the hfc SDK, or directly within the container itself.  See the [chaincode development](http://hyperledger-fabric.readthedocs.io/en/latest/Setup/Chaincode-setup/) section in the Hyperledger fabric documentation for more information on interacting with chaincode.  See the [Fabric Starter Kit](http://hyperledger-fabric.readthedocs.io/en/latest/starter/fabric-starter-kit/) and [hfc SDK guide](http://hyperledger-fabric.readthedocs.io/en/latest/nodeSDK/node-sdk-guide/) for details on using the SDK to interact with your Docker containers.

* For example, get into the Docker container running vp0:
```
docker exec -it dockercompose_vp0_1 bash
```
* Enroll user "test_user0" who is already hardcoded in the membersrvc.yml file:
```
peer network login test_user0 -p MS9qrN8hFjlE
```
* Deploy an example chaincode:
```
peer chaincode deploy -u test_user0 -p github.com/hyperledger/fabric/examples/chaincode/go/chaincode_example02 -c '{"Args": ["init","a", "100", "b", "200"]}'
```
* If you are running on x_86 and see an error similar to:
```
failed Error starting container: invalid endpoint
```
then you may need to adjust the `CORE_VM_ENDPOINT` environment variable.  This variable is the IP address for your Docker daemon.  To find this value:
```
ifconfig docker0
```
or
```
ps -eaf | grep docker
```
Then go into the appropriate peer base image .yaml file and set the value.  For example:
```
CORE_VM_ENDPOINT=172.17.0.1:2375
```
* Issue an invoke transaction.  The chaincode ID used below, after the `-n` argument, is the value returned in the terminal after a successful deployment transaction:
```
peer chaincode invoke -u test_user0 -n ee5b24a1f17c356dd5f6e37307922e39ddba12e5d2e203ed93401d7d05eb0dd194fb9070549c5dc31eb63f4e654dbd5a1d86cbb30c48e3ab1812590cd0f78539 -c '{"Args": ["invoke", "a", "b", "10"]}'
```
* Use the chaincode ID to query against the value of the "a" object:
```
peer chaincode query -u test_user0 -n ee5b24a1f17c356dd5f6e37307922e39ddba12e5d2e203ed93401d7d05eb0dd194fb9070549c5dc31eb63f4e654dbd5a1d86cbb30c48e3ab1812590cd0f78539 -c '{"Args": ["query", "a"]}'
```

## Helpful Docker commands

1. View running containers:

```
docker ps
```
2. View all containers (active and non-active):

```
docker ps -a
```
3. Stop all Docker containers:

```
docker stop $(docker ps -a -q)
```
4. Remove all containers.  Adding the `-f` will issue a "force" removal:

```
docker rm -f $(docker ps -aq)
```
5. Remove all images:

```
docker rmi -f $(docker images -q)
```
6. Remove all images except for hyperledger/fabric-baseimage:

```
docker rmi $(docker images | grep -v 'hyperledger/fabric-baseimage:latest' | awk {'print $3'})
```
7. Start a container:

```
docker start <containerID>
```
8. Stop a containerID:

```
docker stop <containerID>
```
9. View network settings for a specific container:

```
docker inspect <containerID>
```
10. View logs for a specific containerID:

```
docker logs -f <containerID>
```

## Documentation links

1. [Hyperledger fabric](http://hyperledger-fabric.readthedocs.io/en/latest/)
2. [Docker Docs](https://docs.docker.com/)
3. [Stack Overflow](http://stackoverflow.com/questions/tagged/hyperledger)

## Getting support

You can use the [Hyperledger slack](https://slack.hyperledger.org/) community as a starting point for any issues with Docker containers and the Hyperledger fabric codebase.  The community contains a breadth of blockchain expertise from IBMers and external developers, and is a great resource for solving issues and debugging fabric code.  A multi-tiered, dedicated technical support offering is also available for IBM clients.  Visit the [Contact an expert](http://www.ibm.com/blockchain/contact-expert.html) page to learn more about connecting with the IBM Blockchain Engagement Team.  
