# Kubernetes YAML Object Reference

## Basic informations


`apiVersion: string`

apiVersion - Which version of the Kubernetes API you’re using to create this object.  
APIVersion defines the versioned schema of this representation of an object. Servers should convert recognized schemas to the latest internal value, and may reject unrecognized values.  
[More info here](https://git.k8s.io/community/contributors/devel/sig-architecture/api-conventions.md#resources).

**apiVersion:rbac.authorization.k8s.io/v1 :**  Role-based access control (RBAC) is a method of regulating access to computer or network resources based on the roles of individual users within your organization.  
[Check informations here](https://kubernetes.io/docs/reference/access-authn-authz/rbac/).

`kind: string`

kind - What kind of object you want to create.  
Kind is a string value representing the REST resource this object represents. Servers may infer this from the endpoint the client submits requests to. Cannot be updated. In CamelCase.  
[More info here](https://git.k8s.io/community/contributors/devel/sig-architecture/api-conventions.md#types-kinds).

**The StorageClass Resource**

Each StorageClass contains the fields `provisioner`, `parameters`, and `reclaimPolicy`, which are used when a PersistentVolume belonging to the class needs to be dynamically provisioned.

The name of a StorageClass object is significant, and is how users can request a particular class. Administrators set the name and other parameters of a class when first creating StorageClass objects, and the objects cannot be updated once they are created.

Administrators can specify a default StorageClass just for PVCs that don't request any particular class to bind to: see the [PersistentVolumeClaim section](https://kubernetes.io/docs/concepts/storage/persistent-volumes/#persistentvolumeclaims) for details.

`metadata: ObjectMeta`

metadata - Data that helps uniquely identify the object, including a name string, UID, and optional namespace.  
Every object kind MUST have the following metadata in a nested object field called "metadata":  
[More info here](https://kubernetes.io/docs/reference/generated/kubernetes-api/v1.18/#objectmeta-v1-meta) and [Here](https://github.com/kubernetes/community/blob/master/contributors/devel/sig-architecture/api-conventions.md#metadata).

**annotations object:**
Annotations is an unstructured key value map stored with a resource that may be set by external tools to store and retrieve arbitrary metadata. They are not queryable and should be preserved when modifying objects.  
[More info](http://kubernetes.io/docs/user-guide/annotations).


`spec DeploymentSpec`

spec - What state you desire for the object.  
Specification of the desired behavior of the Deployment.  
[More info here](https://kubernetes.io/docs/reference/generated/kubernetes-api/v1.18/#deploymentspec-v1-apps).

`roleRef RoleRef`

RoleRef can only reference a ClusterRole in the global namespace. If the RoleRef cannot be resolved, the Authorizer must return an error.

## Spec Advanced informations

For this part, you'll find wanted specifications informations in this [link](https://kubernetes.io/docs/reference/generated/kubernetes-api/v1.18/#deploymentspec-v1-apps).

`accessModes: string array`

AccessModes contains the desired access modes the volume should have.  
[More info here](https://kubernetes.io/docs/concepts/storage/persistent-volumes#access-modes-1)

The access modes are:
* ReadWriteOnce -- the volume can be mounted as read-write by a single node
* ReadOnlyMany -- the volume can be mounted read-only by many nodes
* ReadWriteMany -- the volume can be mounted as read-write by many nodes

`backend: IngressBackend`

Backend defines the referenced service endpoint to which the traffic will be forwarded to.

`clusterIP: string`

clusterIP is the IP address of the service and is usually assigned randomly by the master. If an address is specified manually and is not in use by others, it will be allocated to the service; otherwise, creation of the service will fail. This field can not be changed through updates. Valid values are "None", empty string (""), or a valid IP address. "None" can be specified for headless services when proxying is not required. Only applies to types ClusterIP, NodePort, and LoadBalancer. Ignored if type is ExternalName.  
[More info here](https://kubernetes.io/docs/concepts/services-networking/service/#virtual-ips-and-service-proxies)

`env: EnvVar array`

List of environment variables to set in the container. Cannot be updated.

`envFrom EnvFromSource array`

List of sources to populate environment variables in the container. The keys defined within a source must be a C_IDENTIFIER. All invalid keys will be reported as an event when the container is starting. When a key exists in multiple sources, the value associated with the last source will take precedence. Values defined by an Env with a duplicate key will take precedence. Cannot be updated.

`type: string`

type determines how the Service is exposed. Defaults to ClusterIP. Valid options are ExternalName, ClusterIP, NodePort, and LoadBalancer. "ExternalName" maps to the specified externalName. "ClusterIP" allocates a cluster-internal IP address for load-balancing to endpoints. Endpoints are determined by the selector or if that is not specified, by manual construction of an Endpoints object. If clusterIP is "None", no virtual IP is allocated and the endpoints are published as a set of endpoints rather than a stable IP. "NodePort" builds on ClusterIP and allocates a port on every node which routes to the clusterIP. "LoadBalancer" builds on NodePort and creates an external load-balancer (if supported in the current cloud) which routes to the clusterIP.  
[More info here](https://kubernetes.io/docs/concepts/services-networking/service/#publishing-services-service-types).

`imagePullPolicy: string`

Image pull policy. One of Always, Never, IfNotPresent. Defaults to Always if :latest tag is specified, or IfNotPresent otherwise. Cannot be updated.  
[More info](https://kubernetes.io/docs/concepts/containers/images#updating-images).

`matchLabels: object`

matchLabels is a map of {key,value} pairs. A single {key,value} in the matchLabels map is equivalent to an element of matchExpressions, whose key field is "key", the operator is "In", and the values array contains only "value". The requirements are ANDed.

`ports: ContainerPort array`

List of ports to expose from the container. Exposing a port here gives the system additional information about the network connections a container uses, but is primarily informational. Not specifying a port here DOES NOT prevent that port from being exposed. Any port which is listening on the default "0.0.0.0" address inside a container will be accessible from the network. Cannot be updated.

`rules IngressRule array`

A list of host rules used to configure the Ingress. If unspecified, or no rule matches, all traffic is sent to the default backend.

`resources: ResourceRequirements`

Compute Resources required by this container. Cannot be updated.  
[More info here](https://kubernetes.io/docs/concepts/configuration/manage-compute-resources-container/).

`restartPolicy: string`

Restart policy for all containers within the pod. One of Always, OnFailure, Never. Default to Always.  
[More info here](https://kubernetes.io/docs/concepts/workloads/pods/pod-lifecycle/#restart-policy).

`replicas: integer`

Number of desired pods. This is a pointer to distinguish between explicit zero and not specified. Defaults to 1.

`selector: LabelSelector`

Label selector for pods. Existing ReplicaSets whose pods are selected by this will be the ones affected by this deployment. It must match the pod template's labels.  
Check the [Link](https://kubernetes.io/docs/reference/generated/kubernetes-api/v1.18/#labelselector-v1-meta).

`strategy: DeploymentStrategy`

The deployment strategy to use to replace existing pods with new ones.
For example we can use *Recreate* keyword.

`stringData: object`

stringData allows specifying non-binary secret data in string form. It is provided as a write-only convenience method. All keys and values are merged into the data field on write, overwriting any existing values. It is never output when reading from the API.

`template: PodTemplateSpec`

Template describes the pods that will be created.

`volumes: Volume array`

List of volumes that can be mounted by containers belonging to the pod.  
[More info](https://kubernetes.io/docs/concepts/storage/volumes).

`volumeMounts: VolumeMount array`

Pod volumes to mount into the container's filesystem. Cannot be updated.

`persistentVolumeClaim: PersistentVolumeClaimVolumeSource`

PersistentVolumeClaimVolumeSource represents a reference to a PersistentVolumeClaim in the same namespace.  
[More info](https://kubernetes.io/docs/concepts/storage/persistent-volumes#persistentvolumeclaims).
And [here](https://kubernetes.io/docs/concepts/storage/persistent-volumes/), you'll also find very usefull informations about persistent volume.