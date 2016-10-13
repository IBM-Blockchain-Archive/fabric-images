# fabric-images

This repository contains the Docker images and Docker Compose files for running the Hyperledger fabric

## Using your Docker Images

These images provide you with a self-contained local blockchain environment running on Hyperledger fabric v0.6 code.  There are two configurations available: 1) a single node + CA (certificate authority) network; and 2) a four node + CA network.  The images and configurations have been tested and verified by IBM development, and should not be altered.  IBM offers support for both configurations.  Please see the **Getting Support** section at the bottom of the page for more information.  

## Platform

The images for the membership services (CA) and peer have been built for the intel (x86), power (ppc64l3), and LinuxONE (s390x) platforms

## Supported configurations

The default configurations for each network (single node and four node) have been tested and verified by IBM for stability and functionality.  Altering the the number of containers in the network is not supported (e.g. 10 peers and 1 CA is not a supported configuration).

## Prerequisites

Ensure that you have Docker for [Mac](https://docs.docker.com/engine/installation/mac/),  [Windows](https://docs.docker.com/engine/installation/windows/) or [Linux](https://docs.docker.com/engine/installation/#/on-linux) 1.12 or higher properly installed on your machine.  You must also have [Docker Compose](https://docs.docker.com/compose/install/) installed.   

## Pulling the Images

[Docker Compose](https://docs.docker.com/compose/) will be used to run the images and spin up your local environment.  By using docker compose, you don't need to execute a `docker pull` command to retrieve the images.  The images are specified in the docker-compose.yml file and will download automatically when you ultimately execute the `docker-compose` command.

## Getting Started and using Docker Compose

1. The docker compose files and configurations are located in GitHub.  If you do not have Git installed, download the appropriate [Git client](https://git-scm.com/downloads) for your OS.  Now clone the repository:

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

## Configuration Considerations

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

## Additional Details for Docker Compose

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

IBM offers support for the single node and four node Docker networks running against the default configurations.  Visit the [support](link here) page to learn more about the pricing structure and specific support offerings.  
