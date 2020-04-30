!/bin/bash

#Author: Guido Diepen

#Convenience script that can help me to easily create a gzip of a given
#data volume. The script is mainly useful if you are using named volumes


#First check if the user provided all needed arguments
if [ "$1" = "" ]
then
        echo "Please provide a source volume name"
        exit
fi

if [ "$2" = "" ]
then
        echo "Please provide a destination folder"
        exit
fi


#Check if the source volume name does exist
docker volume inspect $1 > /dev/null 2>&1
if [ "$?" != "0" ]
then
        echo "The source volume \"$1\" does not exist"
        exit
fi

#Now check if the destination exists
if [ ! -d "$2" ]
then
        echo "The destination folder \"$2\" does not exist"
        exit
fi

echo "Copying data from source volume \"$1\" to destination volume \"$2\"..."
docker run --rm \
           -i \
           -t \
           -v $1:/from \
           -v $2:/to \
           --work-dir /from
           alpine ash -c "tar --exclude caches --exclude workspaces -zcvf \"/to/$1_$(date +%Y%m%d-%H%M%S).tgz\" ."

from=jenkins_jenkins_home
docker run --rm -ti -v $from:/from -v $HOME:/to --workdir /from alpine ash -c "tar --exclude caches --exclude workspace -zcvf \"/to/$from_$(date +%Y%m%d-%H%M%S).tgz\" ."
