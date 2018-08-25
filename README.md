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
vke cluster create --name <name> --region <region> -f sharedfolder -pr sharedproject
```

For region please use the value directed by the staff (either us-west-2 or us-east-1)


## Get Kubectl and Helm

If it isn't already installed on your machine, please install the kubectl command line package for managing Kubernetes.

Kubectl can be pulled down in a variety of ways, including from the VKE UI (on the page for a smartcluster, select actions and then select the correct operating system for your device).

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

Navigating to '<cluster address>/api/v1.0/signups' should return JSON readout of the sample record in the MySQL database.

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
http://<cluster address>:30410
```

This should bring up the Prometheus UI. Navigate to 'Status' -> Targets in the upper bar to verify that all of the components are reporting correctly.

Then go to 'Graph' in the top navigation bar, select a metric, push the 'Execute' button, and then push the 'Add Graph' button. You should see both console return data and a basic graphical execution.

# Grafana

The open platform for beautiful analytics and monitoring

## Installing Grafana from a Helm chart

We will also be deploying Grafana from a stable maintained Helm chart. To do so, run the following command:

```yaml
helm install -n grafana-release stable/grafana --set service.type=NodePort,service.nodePort=30420
```
## Setup Grafana

Now we'll need to setup the Grafana instance and configure it to use our Prometheus deployment as a datasource.

First, we'll need to run the following command to get the admin password for Grafana:

```yaml
   kubectl get secret --namespace default grafana-release -o jsonpath="{.data.admin-password}" | base64 --decode ; echo
```

Please note this password down, as it will be needed shortly.

To access the Grafana UI, navigate to this address in a browser:

```yaml
http://<cluster address>:30420
```
When you reach the login page, login with the username 'admin' and the password found in the previous step.

### Add Prometheus as a datasource

Once logged in to Grafana, the first step will be to configure Prometheus as a datasource. To do this, click 'Add data source' on the Grafana home dashboard.

Once there, we'll need to configure a few parameters. 

For 'Name', use something like 'Prometheus' or 'Prometheus-release'

For 'Type' select 'Prometheus' from the drop down menu.

For URL, enter the address your browsed to in order to access the Prometheus UI (http://<cluster address>:30410) 

Press the 'Save & Test' button. You should see a green 'Data source is working' message pop up. The click the 'Back' button.

## Importing a Dashboard

To visualize the data Grafana can now query from Prometheus, we'll need a dashboard. The most straightforward way to do this is to import an existing one.

We'll import the 'Kubernetes Cluster (Promethues)' dashboard from grafana.com by sekka1.

To do this, please user the nav bar at the left edge of the Grafana UI to navigate to 'Dashboards' (the icon with 4 square panels) -> 'Manage'

Once there, please click the green button labeled '+ Import'

In the 'Grafana.com Dashboard' field, please enter '6417'. Data should autofill as you tab into the next box.

Before you can import the Dashboard, please press the blue 'Change' button in the 'Unique Identifier (uid)' line. Then select the name of your Prometheus datasource from the dropdown menu below and press 'Import' at the bottom.

You should then see a dashboard displayed with gauge panels in a row across the top.

*Based on the Bill Shetti's contianer-fitcycle
http://github.com/bshetti/container-fitcycle*
