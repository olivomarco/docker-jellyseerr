#!/bin/bash

# die function
die() { echo "$*" 1>&2 ; exit 1; }

# usage function
usage() {
    echo "USAGE: ${0} [-h] [-d] [-f]"
    echo ""
    echo "Run docker-compose."
    echo ""
    echo " -h show this help screen"
    echo " -d runs docker-compose down instead of docker-compose up"
    echo " -f force removal of previous docker images"
    echo ""
}

# parse arguments
DOWN=0
REMOVE=0
while getopts ":hdf" opt; do
    case $opt in
        h)
            usage
            exit 1
            ;;
        d)
            DOWN=1
            ;;
        f)
            REMOVE=1
            ;;
        \?)
            echo "Invalid option: -${OPTARG}" >&2
            usage
            exit 1
            ;;
    esac
done
shift $((OPTIND -1))

export INT_DOMAIN=$(hostname --fqdn)
export EXT_DOMAIN=$(hostname).olivo.net

# check folders
if [ ! -d /data ] || [ ! -d /multimedia ] ; then
    echo "ERROR: one or more of /data, /multimedia folders does not exist. Please check your paths."
    exit 1
fi

if [ $DOWN -eq 0 ] ; then
    echo "issuing docker-compose up..."
    docker-compose -f docker-compose.yml -p jellyseer up -d || die "Cannot create container!"
else
    echo "issuing docker-compose down..."
    docker-compose -f docker-compose.yml -p jellyseer down || die "Cannot stop container!"
fi

# remove previous docker images?
if [ $REMOVE -eq 1 ] ; then
    images=$(cat docker-compose.yml | grep ":latest" | sed -e 's/.*image: //g')
    for img in $images ; do
        docker rmi $img
    done
fi
