
Heco - Installation and configuration of an Hadoop Ecosystem
============================================================

Heco provide a set of commands to install, configure and manage your Hadoop Ecosystem. At the moment, it is focusing on local developer installation.

Installation
------------

```bash
git clone http://github.com/wdavidw/heco.git
cd heco
npm install
npm link
heco help
heco install
```

On OSX, install xcode, I didn't encounter any particular issue, but maybe was it because I already had all the dependencies.

On a fresh Ubuntu 11.04 installation, you will need to prepare the system as follow.

```bash
# Install Sun Java JDK (recommended by Hadoop)
UBUNTU_REPO='deb http://archive.canonical.com/ubuntu maverick partner'
sudo echo $UBUNTU_REPO > /etc/apt/sources.list.d/ubuntu_partner.list
sudo echo 'export JAVA_HOME=/usr/lib/jvm/java-6-sun' > /etc/profile.d/java.sh
sudo apt-get update
sudo apt-get install sun-java6-jdk
# For Hive and Hue
sudo apt-get install mysql-server
# For Hue
sudo apt-get install python2.7-dev
sudo apt-get install libxslt-dev
sudo apt-get install libmysqlclient-dev
sudo apt-get install libsqlite3-dev
sudo apt-get install libsasl2-dev
sudo apt-get install maven2
sudo apt-get install asciidoc
```

On Ubuntu 11.10, Hue installation failed, see:
https://issues.cloudera.org/browse/HUE-599?page=com.atlassian.jira.plugin.system.issuetabpanels%3Aall-tabpanel#issue-tabs