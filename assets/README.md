# Kubernetes Object Reference

- ![#f03c15](https://via.placeholder.com/15/f03c15/000000?text=+) `#f03c15`
- ![#c5f015](https://via.placeholder.com/15/c5f015/000000?text=+) `#c5f015`
- ![#1589F0](https://via.placeholder.com/15/1589F0/000000?text=+) `#1589F0`

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
