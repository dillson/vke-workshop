# Setup a VKE Cluster

## Login to VKE UI and Download the CLI package

Download the CLI package from the button in the bottom left corner of the screen labeled 'Download CLI' and slecting the correct operating system. Make sure it has execute permissions.

## Login to the VKE CLI

Use the following format, replacing organization-id with your organization ID and refresh-token with your refresh token.

```yaml
vke account login -t *organization-id* -r *refresh-token*
```

The organization ID is available in the VKE UI by clicking on the box showing your username and organization name in the upper right portion of the screen. Please click on the Org ID to get the long form and use that long form in the command.

For an API/refresh token, please click again on the box displaying your username and organization name. Then please click on the 'My Account' button.

On the resulting page, please select 'API tokens' the third option in the horizontal navigation bar under 'My Account'. If you have an existing token, please copy and use it, otherwise please click the button labelled 'New Token' and then copy the result.

## Create a cluster

To create a VKE cluster, run the following command:

```yaml
vke cluster create --name <name> --region <region>
```

For region please use the value directed by the staff (either us-west-2 or us-east-1)


## Get Kubectl and Helm

If it isn't already installed on your machine, please install the kubectl command line package for managing Kubernetes.

Kubectl and be pulled down in a variety of ways, including from the VKE UI (on the page for a smartcluster, select actions and then select the correct operating system for your device).

For Helm, please see the following page: [Helm](https://github.com/helm/helm)

## Access the VKE Cluster

To gain kubectl access to your VKE cluster via the command line use the following command:

```yaml
vke cluster merge-kubectl-auth <cluster name>
```

This will authenticate kubectl to your VKE cluster and set the correct context to access that cluster.

Correct funtionality can be verfied by successfully running 'kubectl get' commands against the cluster (kubectl get nodes, kubectl get pods, etc)

# Install Fitcycle

Fitcycle (maintained by Bill Shetti) is our test app. It is comprised of mutliple service (web fronted, mysql database, api server to read the database). We will install it using a simple script.

## Get the Fitcycle repo

For this workshop, please clone the git repo [here](https://github.com/dillson/vke-workshop) or download the files.

## Run setup.sh

Installing Fitcycle on a VKE cluster is easy via the included setup.sh script. To start, be sure that the following scripts (setup.sh, setingress.sh, setenv, and gethost.sh) are all executable on your machine.

The run the setup.sh bash script with 2 arguments:

```yaml
./setup.sh <DB password> <cluster name>
```

The database password is entirely internal to the process, so use any value you like, even 'password'. The cluster name is not, this is the name of the VKE cluster created previously in these directions. 

## Validate Fitcycle

To validate Fitcycle, we'll check that the various components run as expected.

First, get the cluster address:

```yaml
vke cluster show <cluster name> | grep Address:
```

The result of this command provides the base URL used to access exposed services within the cluster.

To test, enter that URL with a trailing '/' into a web browser. This should bring up the Fitcycle web frontend page.

Navingating to '<cluster address>/api/v1.0/signups' should return JSON readout of the sample record in the MySQL database.

If you do not get these results, please ask the workshop staff for help.

# Prometheus

Prometheus, a Cloud Native Computing Foundation project, is a systems and service monitoring system. It collects metrics from configured targets at given intervals, evaluates rule expressions, displays the results, and can trigger alerts if some condition is observed to be true.

## Initiailize Helm

To setup Tiller (the cluster side component of Helm) in your VKE cluster, run the following command:

```yaml
helm init
```

## Install Prometheus from a Helm chart

To install Prometheus from the stable maintained Helm chart, we will run the following command:

```yaml
helm install -n prometheus-release stable/prometheus --set server.service.type=NodePort,server.service.nodePort=30410
```

To watch the pods create and run, run the 'kubectl get pods -w' command while this completes

## Validate the Prometheus Install

To ensure Prometheus in correctly deployed, navigate to the following in a browser:

```yaml
<cluster name>:34010
```

This should bring up the Prometheus UI. Navigate to 'Status' -> Targets in the upper bar to verify that all of the components are reporting correctly.

Then go to 'Graph' in the top navigation bar, select a metric, and push the 'Add Graph' button. You should see both console return data and a basic graphical execution.

# Grafana



*Based on the Bill Shetti's contianer-fitcycle
http://github.com/bshetti/container-fitcycle*
