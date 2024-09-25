## Volumes

On-disk files in a container are ephemeral, they are gone when a container crashes or is stopped. Persisting container state or data in a volume is required in some applications.

Kubernetes supports two categories of volumes: ephemeral volumes and persistent volumes. The former have a lifetime of a pod (it's gone when a pod ceases to exist); the latter exist beyond the lifetime of a pod.

Use `.spec.volumes` to specify volumes for a pod. And use `.spec.containers[*].volumeMounts` to declare where to mount those volumes into containers.

### Types of volumes ###

**configMap**

Data stored in a `ConfigMap` can be referenced in a volume and then consumed by the container.

**Note:** A ConfigMap is always mounted as `readOnly`.

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: configmap-pod
spec:
  containers:
    - name: test
      mage: 'busybox:1.28'
      command:
        - sh
        - '-c'
        - echo "The app is running!" && tail -f /dev/null
      volumeMounts:
        - name: config-vol
          mountPath: /etc/config
  volumes:
    - name: config-vol
      configMap:
        # use name to reference to the configMap
        name: log-config
        items:
            # data stored in this key are mounted at path /etc/config/config/log_level
          - key: log_level
            path: log_level
```

**secret**

A `secret` resource can be mounted into a pod as a *secret volume*. `secret` volumes are backed by `tmpfs` (which is a RAM-backed filesystem) so they are never written to non-volatile storage.

**Note:** A secret is always mounted as `readOnly`.

```yaml
apiVersion: v1
kind: Secret
metadata:
  name: dotfile-secret
data:
  .secret-file: dmFsdWUtMg0KDQo=
---
apiVersion: v1
kind: Pod
metadata:
  name: secret-dotfiles-pod
spec:
  volumes:
    - name: secret-volume
      secret:
        secretName: dotfile-secret
  containers:
    - name: dotfile-test-container
      image: registry.k8s.io/busybox
      command:
        - ls
        - '-l'
        - /etc/secret-volume
      volumeMounts:
        - name: secret-volume
          readOnly: true
          mountPath: /etc/secret-volume
```

**emptyDir**

An `emptyDir` is created when a pod is assigned to a node. Containers in the same pod can read and write the same files in the `emptyDir` volume. The same `emptyDir` volume can be mounted at the same or different paths in each container.

**Note:** If a pod is gone, data in the `emptyDir` is deleted permanently.

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: test-pd
spec:
  containers:
    - image: registry.k8s.io/test-webserver
      name: test-container
      volumeMounts:
        - mountPath: /cache
          name: cache-volume
  volumes:
    - name: cache-volume
      emptyDir:
        sizeLimit: 500Mi
```

**hostPath**

`hostPath` volume mounts a file or directory from the host node's filesystem into a pod.

Be cautious when using `hostPath` volumes, in many cases, `local` volumes are preferred.

a `hostPath` volume can be used:
- running a container that needs access to node-level system components. For example, a container that tyransfers system logs to a central location, accessing those logs using a read-only mount of `/var/log`.

```yaml
# This manifest mounts /data/foo on the host as /foo inside the
# single container that runs within the hostpath-example-linux Pod.
#
# The mount into the container is read-only.
apiVersion: v1
kind: Pod
metadata:
  name: hostpath-example-linux
spec:
  os:
    name: linux
  nodeSelector:
    kubernetes.io/os: linux
  containers:
    - name: example-container
      image: registry.k8s.io/test-webserver
      volumeMounts:
        - mountPath: /foo
          name: example-volume
          readOnly: true
  volumes:
    - name: example-volume
      hostPath:
        path: /data/foo
        type: Directory
```

**local**

A `local` volume represents a mounted local storage device such as a disk, partition, or directory.
- used as a statically created PersistentVolume.
- durable and portable
- subject to the availability of the underlying node, 
    - tolerance to reduced availability, potential data loss.

```yaml
apiVersion: v1
kind: PersistentVolume
metadata:
  name: example-pv
spec:
  capacity:
    storage: 100Gi
  # another volume mode is `Block` as a raw block device
  volumeMode: Filesystem
  accessModes:
  - ReadWriteOnce
  persistentVolumeReclaimPolicy: Delete
  storageClassName: local-storage
  local:
    path: /mnt/disks/ssd1
  nodeAffinity:
    required:
      nodeSelectorTerms:
      - matchExpressions:
        - key: kubernetes.io/hostname
          operator: In
          values:
          - example-node
---
apiVersion: storage.k8s.io/v1
kind: StorageClass
metadata:
  name: local-storage
provisioner: kubernetes.io/no-provisioner
volumeBindingMode: WaitForFirstConsumer
```

`nodeAffinity` is required for `local` volumes. K8s scheduler uses the PV `nodeAffinity` to schedule these pods to the correct node.

**nfs**

An `nfs` volome mounts an existing NFS (Network-File-System) share into a pod.
- content in an `nfs` volume is preserved
- if a pod is gone, the volume is unmounted
- can be pre-populated and persisted
- can be mounted by multiple writers at the same time

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: test-pd
spec:
  containers:
  - image: registry.k8s.io/test-webserver
    name: test-container
    volumeMounts:
    - mountPath: /my-nfs-data
      name: test-volume
  volumes:
  - name: test-volume
    nfs:
      server: my-nfs-server.example.com
      path: /my-nfs-volume
      readOnly: true
```

**persistentVolumeClaim**

A pv claim is used to mount a `PersistentVolume` into a pod.
- used to claim durable storage w/o knowing the detail of the particular cloud environment

```yaml
apiVersion: v1
kind: PersistentVolume
metadata:
  name: nfs
spec:
  capacity:
    storage: 1Mi
  accessModes:
    - ReadWriteMany
  nfs:
    server: nfs-server.default.svc.cluster.local
    path: "/"
  mountOptions:
    - nfsvers=4.2
---
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: nfs
spec:
  accessModes:
    - ReadWriteMany
  storageClassName: ""
  resources:
    requests:
      storage: 1Mi
  volumeName: nfs    
```

## Persistent Volumes

A `PersistentVolume` is provisioned either by cluster administrator (statically) or dynamically using a `StorageClass`.
- it is cluster resource
- its lifecycle is independent of any pod that uses the PV
- it is requested/claimed through a `PersistentVolumeClaim` by a pod
- PVC to PV binding is one-to-one mapping.
  - if a PV is dynamically provisioned for a new PVC, the binding is always maintained.


```yaml
```
