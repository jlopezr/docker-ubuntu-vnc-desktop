#!/bin/bash
IMAGE=flowit/desktop
SERVER=hub.aaaida.com:5000
PUSH=0
TEST=0
TAG=""
DATE=`date "+%Y%m%d.%H%M"`
# -------

usage() { echo "Usage: $0 [--push] [--test] [--tag <extra-tag>]" 1>&2; exit 1; }

while :; do
    case $1 in
        -h|-\?|--help)   # Call a "show_help" function to display a synopsis, then exit.
            usage
            exit
            ;;
        -p|--push)
            PUSH=1
            ;;
        -T|--test)
            TEST=1
            ;;
        -t|--tag)       # Takes an option argument, ensuring it has been specified.
            if [ -n "$2" ]; then
                TAG=$2
                shift
            else
                printf 'ERROR: "--tag" requires a non-empty option argument.\n' >&2
                exit 1
            fi
            ;;
        --tag=?*)
            TAG=${1#*=} # Delete everything up to "=" and assign the remainder.
            ;;
        --tag=)         # Handle the case of an empty --file=
            printf 'ERROR: "--tag" requires a non-empty option argument.\n' >&2
            exit 1
            ;;
        --)              # End of all options.
            shift
            break
            ;;
        -?*)
            printf 'WARN: Unknown option (ignored): %s\n' "$1" >&2
            ;;
        *)               # Default case: If no more options then break out of the loop.
            break
    esac

    shift
done

# -------

function enable_docker_machine {
    unamestr=`uname`
    if [[ "$unamestr" != 'Linux' ]]; then
        STATUS=$(docker-machine status default)
        if [ "$STATUS" != "Running" ]; then
            docker-machine start default
            docker-machine ssh default << EOF
sudo sh -c 'echo "178.62.241.37   staging staging.do" >> /etc/hosts'
sudo sh -c 'echo "128.199.53.150  testing testing.do" >> /etc/hosts'
EOF
        fi
        eval $(docker-machine env --shell bash default)
    fi
}


if [[ $PUSH -eq 1 ]]; then
  echo "[BUILD] Image will be pushed to server."
fi
if [[ $TEST -eq 1 ]]; then
  echo "[BUILD] Image will be generated in TEST mode."
  IMAGE=$IMAGE-test
fi
if [[ "$TAG" != "" ]]; then
    echo "[BUILD] EXTRA TAG will be $TAG"
    TAGCMD="-t $SERVER/$IMAGE:$TAG"
fi

docker build -t $SERVER/$IMAGE:$DATE $TAGCMD -t $SERVER/$IMAGE .
if [[ $? -eq 0 && $PUSH -eq 1 ]]; then
    docker push $SERVER/$IMAGE:latest
    docker push $SERVER/$IMAGE:$DATE
    if [[ "$TAG" != "" ]]; then
        docker push $SERVER/$IMAGE:$TAG
    fi
fi
echo "[BUILD] VERS. TAG is $SERVER/$IMAGE:$DATE"
if [[ "$TAG" != "" ]]; then
    echo "[BUILD] EXTRA TAG is $SERVER/$IMAGE:$TAG"
fi
