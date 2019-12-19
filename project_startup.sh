#!/bin/bash
#
# Bootstrap to load the project

HERE=$(dirname $0)
cd $HERE

. /etc/sqlstream/environment
export PATH=$PATH:$SQLSTREAM_HOME/bin:$HERE

# wait for the image to be started

while [ 1 -eq 1 ]
do
    curl http://localhost:5580/status 2>/dev/null
    if [ $? -eq 0 ]
    then
        break
    fi
    echo waiting for s-Server
    sleep 5
done

sleep 30

# do some pre-project setup
preproject.sh

for f in *.slab
do
    if [ -e $f ]
    then
        echo
        echo posting $f

        # TODO check if project already exists, fail if so

        (
             # We need to insert adjustments into the slab file just before the final }
             # these elements include their quotes
 
             title=$(cat $f | jq .projectModel.title)
             schema=$(cat $f | jq .projectModel.projectSchema)
             
             # and we have to wrap the whole thing with the outer elements here
         
             cat $f | sed -e 's/}$//' ; echo ", \"adjustments\": {\"newName\":\"$(basename $f .slab)\",\"newTitle\":$title,\"newSchema\":$schema, \"setProtect\": \"false\"}}" 
        ) > /tmp/$f.1

        # now stringify the slab file
        cat /tmp/$f.1 | jq '. | tostring' > /tmp/$f.2

        # and wrap it up for the call into a single line
        (echo '{"username": "user", "json":' ; cat /tmp/$f.2 ; echo '}' ) | sed -e 's/\n//'  > /tmp/$f.3 
        
        # call the API
        curl -H "Content-Type: application/json" -d@/tmp/$f.3 http://localhost:5585/_project_import/user

        # TODO check response

        rm /tmp/$f.{1,2,3}
        echo

    else
        echo No such project export file $f
    fi
done

# do some post-project setup
postproject.sh


