# PublicServantsPrayer.org Website

## Installation Instructions:

Set hostname:

    echo "publicservantsprayer.org" > /etc/hostsname

Upgrade packages:

    aptitude update && aptitude upgrade

(keep locally modified grub if asked)

Install public key, delete root password

Install packages to enable PPA repositories

    apt-get -y install curl git-core python-software-properties

Add Nginx repository

    add-apt-repository ppa:nginx/stable

Update the package manager with the new repository and install Nginx

    aptitude update  && aptitude -y install nginx

Start Nginx

    service nginx start

Add repository for latest version of PostgreSQL

    add-apt-repository ppa:pitti/postgresql

Update repo and install PostgreSQL

    aptitude update && aptitude install postgresql libpq-dev



