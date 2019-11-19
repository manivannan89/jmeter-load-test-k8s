#!/usr/bin/env bash
#Script writtent to stop a running jmeter master test
#Kindly ensure you have the necessary kubeconfig

working_dir=`pwd`

#Get namesapce variable
tenant=`awk '{print $NF}' $working_dir/tenant_export`

master_pod=`kubectl get po -n $tenant | grep jmeter-master | awk '{print $1}'`

kubectl -n $tenant exec -ti $master_pod bash apache-jmeter-5.1.1/bin/stoptest.sh
