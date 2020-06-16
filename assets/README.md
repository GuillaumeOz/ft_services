# Kubernetes Object Reference

<div class="text-purple">
  This text is purple, <a href="#" class="text-inherit">including the link</a>
</div>

<span style="color:cornflowerBlue">apiVersion:<span style="color:chocolate"> v1</span></span>

<div class="yaml_color_syntax">
  <span style="color:cornflowerBlue">apiVersion:<span style="color:chocolate"> v1</span></span>
</div>

# APIVersion defines the versioned schema of this representation of an object. Servers should convert recognized schemas to the latest internal value, and may reject unrecognized values. More info: https://git.k8s.io/community/contributors/devel/sig-architecture/api-conventions.md#resources
# apiVersion - Which version of the Kubernetes API you’re using to create this object
apiVersion: v1

# kind - What kind of object you want to create
# metadata - Data that helps uniquely identify the object, including a name string, UID, and optional namespace
# spec - What state you desire for the object
