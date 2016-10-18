# LinuxONE Instance
Request an account at https://developer.ibm.com/linuxone/ and create a RHEL 7.2 instance.

# From pristine environment to peer network

 ```
ssh linux1@<instance ip address>
sudo su
cd /tmp
wget ftp://ftp.unicamp.br/pub/linuxpatch/s390x/redhat/rhel7.2/docker-1.11.2-rhel7.2-20160623.tar.gz
tar -xvzf docker-1.11.2-rhel7.2-20160623.tar.gz
cp docker-1.11.2-rhel7.2-20160623/docker* /bin/
nohup docker daemon -g /data/docker -H tcp://0.0.0.0:2375 -H unix:///var/run/docker.sock &
yum install pip
yum install -y python-setuptools
curl "https://bootstrap.pypa.io/get-pip.py" -o "get-pip.py"
python get-pip.py
pip install --upgrade pip
pip install docker-compose
cd
git clone https://github.com/IBM-Blockchain/fabric-images
cd fabric-images/docker-compose/
source setenv.sh
docker-compose -f four-peer-ca.yaml up
```
