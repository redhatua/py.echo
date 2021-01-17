# Simple echo server written in python
This app displays any requested URI as string and also show IP address of machine where it's running. If URI is `/index.html` this static page will be displayed.

## Before you go...
### To build, prepare environment and deploy application to AWS these steps should be done.
#### Packages present on the system:
    - awscli
    - docker
    - kubectl
    - terraform
    - wget
#### AWS account with [these](https://github.com/redhatua/py.echo/IAM.md) IAM permissions
#### awscli configured with given credentials

## How to:

### Setup AWS EKS cluster and get kubectl configured to work with it
#### Init and applying terraform

```shell
$ cd terraform
$ terraform init
$ terraform plan
$ terraform apply
```
:memo: Note: `terraform apply` with `-auto-approve` can be used as well

#### Getting EBS cluster access
```shell
$ aws eks --region $(terraform output -raw region) update-kubeconfig --name $(terraform output -raw cluster_name)
```

### Kubernetes deployment and service exposing 
#### Container build 
First of all we have to build docker image and push it somewhere to public or configured private docker registry. Pushing changes to this repository will also build and push `redhatua/echo` image to dockerhub which also can be used as well.

```shell
$ export DOCKER_TAG=mytag
$ docker build -t $DOCKER_TAG .
```
After build image can be tested locally `-v <path_to_index_file>:/app/index.html` can be added to mount custom index file
```shell
$ docker run --rm -ti -p 8080:8080 $DOCKER_TAG
```

Also don't forget to replace image tag in [kubernetes/deployment.yaml](https://github.com/redhatua/py.echo/blob/master/kubernetes/deployment.yaml)
```shell
$ sed -i 's/redhatua\/echo/'"$DOCKER_TAG"'/g' kubernetes/deployment.yaml
```
And we finally can deploy it to cluster.
```shell
$ cd kubernetes
$ kubectl -f deployment.yaml apply
```
:bulb: Tip: getting exposed deployment URL
```shell
$ kubectl get svc | grep 'echo-app-service' | awk -v prefix="http://" '{ print prefix $4 }'
```

### Shutdown
#### Kubernetes deployment
```shell
$ cd kubernetes
$ kubectl -f deployment.yaml delete
```
#### AWS infrastructure
```shell
$ cd terraform
$ terraform destroy -auto-approve
```
