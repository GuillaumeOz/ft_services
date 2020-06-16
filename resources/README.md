# Kubernetes YAML Object Reference

## Basic informations


`apiVersion: string`

apiVersion - Which version of the Kubernetes API you’re using to create this object.  
APIVersion defines the versioned schema of this representation of an object. Servers should convert recognized schemas to the latest internal value, and may reject unrecognized values.  
[More info here](https://git.k8s.io/community/contributors/devel/sig-architecture/api-conventions.md#resources).


`kind: string`

kind - What kind of object you want to create.  
Kind is a string value representing the REST resource this object represents. Servers may infer this from the endpoint the client submits requests to. Cannot be updated. In CamelCase.  
[More info here](https://git.k8s.io/community/contributors/devel/sig-architecture/api-conventions.md#types-kinds).


`metadata ObjectMeta`

metadata - Data that helps uniquely identify the object, including a name string, UID, and optional namespace.  
Every object kind MUST have the following metadata in a nested object field called "metadata":  
[More info here](https://kubernetes.io/docs/reference/generated/kubernetes-api/v1.18/#objectmeta-v1-meta) and [Here](https://github.com/kubernetes/community/blob/master/contributors/devel/sig-architecture/api-conventions.md#metadata).

#######################
		TODO
#######################

`spec DeploymentSpec`

spec - What state you desire for the object.  
Specification of the desired behavior of the Deployment.  
[More info here](https://kubernetes.io/docs/reference/generated/kubernetes-api/v1.18/#deploymentspec-v1-apps).


## Spec Advanced informations

For this part, you'll find wanted specifications informations in this [link](https://kubernetes.io/docs/reference/generated/kubernetes-api/v1.18/#deploymentspec-v1-apps).

`accessModes string array`

AccessModes contains the desired access modes the volume should have.  
[More info here](https://kubernetes.io/docs/concepts/storage/persistent-volumes#access-modes-1)

The access modes are:
* ReadWriteOnce -- the volume can be mounted as read-write by a single node
* ReadOnlyMany -- the volume can be mounted read-only by many nodes
* ReadWriteMany -- the volume can be mounted as read-write by many nodes

`clusterIP string`

clusterIP is the IP address of the service and is usually assigned randomly by the master. If an address is specified manually and is not in use by others, it will be allocated to the service; otherwise, creation of the service will fail. This field can not be changed through updates. Valid values are "None", empty string (""), or a valid IP address. "None" can be specified for headless services when proxying is not required. Only applies to types ClusterIP, NodePort, and LoadBalancer. Ignored if type is ExternalName.  
[More info here](https://kubernetes.io/docs/concepts/services-networking/service/#virtual-ips-and-service-proxies)

`ports ContainerPort[] array`

List of ports to expose from the container. Exposing a port here gives the system additional information about the network connections a container uses, but is primarily informational. Not specifying a port here DOES NOT prevent that port from being exposed. Any port which is listening on the default "0.0.0.0" address inside a container will be accessible from the network. Cannot be updated.

`resources ResourceRequirements`

Compute Resources required by this container. Cannot be updated.  
[More info here](https://kubernetes.io/docs/concepts/configuration/manage-compute-resources-container/).

`restartPolicy: string`

Restart policy for all containers within the pod. One of Always, OnFailure, Never. Default to Always.  
[More info here](https://kubernetes.io/docs/concepts/workloads/pods/pod-lifecycle/#restart-policy).

`replicas: integer`

Number of desired pods. This is a pointer to distinguish between explicit zero and not specified. Defaults to 1.

`selector: LabelSelector`

Label selector for pods. Existing ReplicaSets whose pods are selected by this will be the ones affected by this deployment. It must match the pod template's labels.  
[Link](https://kubernetes.io/docs/reference/generated/kubernetes-api/v1.18/#labelselector-v1-meta).

`strategy: DeploymentStrategy`

The deployment strategy to use to replace existing pods with new ones.
For example we can use *Recreate* keyword.

`template: PodTemplateSpec`

Template describes the pods that will be created.

