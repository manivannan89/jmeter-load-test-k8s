#!/usr/bin/env bash
#Create multiple Jmeter namespaces on an existing kuberntes cluster

current_dir=`pwd`
working_dir="$(dirname "$current_dir")"

echo
echo "checking if kubectl is present"

if ! hash kubectl 2>/dev/null
then
    echo "'kubectl' was not found in PATH"
    echo "Kindly ensure that you can acces an existing kubernetes cluster via kubectl"
    exit
fi

kubectl version --short
echo

echo "Current list of namespaces on the kubernetes cluster:"

kubectl get namespaces | grep -v NAME | awk '{print $1}'

echo

echo "Enter the name of the new tenant unique name, this will be used to create the namespace"
read tenant
echo

#Check If namespace exists

kubectl get namespace $tenant > /dev/null 2>&1

if [ $? -eq 0 ]
then
  echo "Namespace $tenant already exists, please select a unique name"
  echo "Current list of namespaces on the kubernetes cluster"
  sleep 2

 kubectl get namespaces | grep -v NAME | awk '{print $1}'
 echo
  exit 1
fi

echo "Creating Namespace: $tenant"

kubectl create namespace $tenant

echo

echo "Creating Jmeter slave nodes"

nodes=`kubectl get no | egrep -v "master|NAME" | wc -l`

echo

echo "Number of worker nodes on this cluster is " $nodes

echo

echo "Creating Jmeter slave replicas and service"

kubectl create -n $tenant -f $working_dir/k8s/deployments/jmeter_slaves_deploy.yaml

kubectl create -n $tenant -f $working_dir/k8s/services/jmeter_slaves_svc.yaml

echo "Creating Jmeter Master"

kubectl create -n $tenant -f $working_dir/k8s/config-maps/jmeter_master_configmap.yaml

kubectl create -n $tenant -f $working_dir/k8s/deployments/jmeter_master_deploy.yaml

echo "Creating Jmeter storage class and PVCs"

kubectl apply -f $working_dir/k8s/storage-classes/jmeter_sc.yaml

kubectl create -n $tenant -f $working_dir/k8s/persistent-volume-claims/jmeter_influxdb_pvc.yaml

kubectl create -n $tenant -f $working_dir/k8s/persistent-volume-claims/jmeter_grafana_dashboard_pvc.yaml

echo "Creating Influxdb and the service"

kubectl create -n $tenant -f $working_dir/k8s/config-maps/jmeter_influxdb_configmap.yaml

kubectl create -n $tenant -f $working_dir/k8s/deployments/jmeter_influxdb_deploy.yaml

kubectl create -n $tenant -f $working_dir/k8s/services/jmeter_influxdb_svc.yaml

echo "Creating Grafana Deployment"

kubectl create -n $tenant -f $working_dir/k8s/deployments/jmeter_grafana_dashboard_deploy.yaml

kubectl create -n $tenant -f $working_dir/k8s/services/jmeter_grafana_dashboard_svc.yaml

echo "Printout Of the $tenant Objects"

echo

kubectl get -n $tenant all

echo namespace = $tenant > $working_dir/scripts/tenant_export
