#! /bin/bash

# Define project variables
ENV="dev"
PROJECT="hello_world"
DATE=$(date +'%Y-%m-%d')
MODE="local"

function get_aws_profile()
{
    AWS_ACC_ID=$(aws sts get-caller-identity --query "Account" --output text)
    AWS_DEFAULT_REGION=$(aws --profile default configure get region)
    AWS_ACCESS_KEY_ID=$(aws --profile default configure get aws_access_key_id)
    AWS_SECRET_ACCESS_KEY=$(aws --profile default configure get aws_secret_access_key)
}

function login()
{
    aws ecr get-login-password --region $AWS_DEFAULT_REGION | docker login --username AWS --password-stdin $AWS_ACC_ID.dkr.ecr.$AWS_DEFAULT_REGION.amazonaws.com
}

function build()
{
    docker build -t $PROJECT:latest .
}

function run()
{
    docker run -it --rm -p 9000:8080 -e AWS_ACCESS_KEY_ID=$AWS_ACCESS_KEY_ID -e AWS_SECRET_ACCESS_KEY=$AWS_SECRET_ACCESS_KEY -e AWS_DEFAULT_REGION=$AWS_DEFAULT_REGION $PROJECT:latest
}

function build_run()
{
    build
    run
}

function build_tag_push()
{
    login
    build
    docker tag $PROJECT:latest $AWS_ACC_ID.dkr.ecr.$AWS_DEFAULT_REGION.amazonaws.com/$PROJECT:latest
    docker push $AWS_ACC_ID.dkr.ecr.$AWS_DEFAULT_REGION.amazonaws.com/$PROJECT:latest
    update_lambda
}

function update_lambda()
{
    aws lambda update-function-code --function-name $PROJECT --image-uri $AWS_ACC_ID.dkr.ecr.$AWS_DEFAULT_REGION.amazonaws.com/$PROJECT:latest
}

function intro()
{
    printf "Reading AWS Profile Info\n"
    get_aws_profile
    printf "\nAWS_ACC_ID=$AWS_ACC_ID\n"
    printf "AWS_DEFAULT_REGION=$AWS_DEFAULT_REGION\n"
    printf "AWS_ACCESS_KEY_ID=$AWS_ACCESS_KEY_ID\n"
    printf "AWS_SECRET_ACCESS_KEY=$AWS_SECRET_ACCESS_KEY\n\n"

    printf "PROJECT: $PROJECT $DATE\n"
    printf "l: ecr login\n"
    printf "b: docker build\n"
    printf "r: docker run\n"
    printf "u: docker build run\n"
    printf "p: docker login build tag push update\n"
    printf "z: update lambda"
    printf "> "

    read arg
}


intro

if   [ $arg == "l" ]; then login;
elif [ $arg == "b" ]; then build;
elif [ $arg == "r" ]; then run;
elif [ $arg == "u" ]; then build_run;
elif [ $arg == "p" ]; then build_tag_push;
elif [ $arg == "z" ]; then update_lambda;

else printf "unknown arg";
fi