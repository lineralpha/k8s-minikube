# Kubernetes Concepts

## Network model

Every Pod AND Service in a cluster gets its own unique cluster IP address. Pods within same cluster can talk to each other through their cluster IPs. You almost never need to deal with mapping container ports to host ports.

Pods are the smallest deployable units of computing that you can create and manage in k8s. Pods can be treated muck like VMs from perspectives of networking.
- IP per pod:
    - Containers within a pod share their network namespaces - both IP and MAC addresses, i.e., containers within a pod can reach each other's ports on `localhost`.
- pods can communicate with all all other pods on any node w/o [NAT][1].
- agents (kubelet, system daemons) on a node can communicate with all pods on that node. 
- services can expose applications running in pods to be reachable from outside the cluster.
    - ingress provides extra functionality specifically fof exposing HTTP apps, websites and APIs.
    - gateway API provides role-oriented family of API kinds for modeling service networking.
- services can be used for consumption only inside cluster.


## [Service][2]

A service exposes endpoints in a group of pods to either other pods in the cluster or clients outside the cluster, depending on how the service is configured.
- service gets a cluster IP, regardless the service type it is configured.
- service abstracts access to pods which are ephemeral.

**Service w/o a Selector**

A service normally uses a selector to match pods. But you can create selectorless services:
- you want to have an external database cluster in prod, but in your staging or  test env you use your own databases.
- you want to point to another service in a different namespance or on another cluster.
- your app is migrating to k8s. while the migration is in progress, you run only a portion of your backends in k8s.

    ```yaml
    apiVersion: v1
    kind: Service
    metadata:
      name: my-service
    spec:
      ports:
        - name: http
          protocol: TCP
          port: 80
          targetPort: 9376    
    ```

**Multi-port Services**

Multiple port definitions can be configured on a service. In that case, each port must have its own name to eliminate ambiguity.

    ```yaml
    apiVersion: v1
    kind: Service
    metadata:
      name: my-service
    spec:
      selector:
        app.kubernetes.io/name: myapp
    ports:
      - name: http
        protocol: TCP
        port: 80
        targetPort: 9376    
      - name: https
        protocol: TCP
        port: 443
        targetPort: 9377    
    ```

**Service Types**

The four service types are:
- ClusterIP: service only reachable from within the cluster. Use `ingress` or `gataway` to make it available to public.
    - Headless: set `ClusterIP` to `none`
- NodePort: as its name implies, service is exposed on the node's IP at a static port. Services of this type are accessible from outside the cluster.
- LoadBalancer: service is exposed externally. Note: k8s does not offer a load balancer. An external load balancer (e.g. one from a cloud provider) is required.
    - `minikube` can do the trick by running command `minikube service` or `minikube tunnel` 
- ExternalName

## [Ingress][3]

Ingress is frozen. New features are added to the `Gateway API`.

    ```yaml
    apiVersion: networking.k8s.io/v1
    kind: Ingress
    metadata:
      name: minimal-ingress
    annotations:
      nginx.ingress.kubernetes.io/rewrite-target: /
    spec:
      ingressClassName: nginx-example
      defaultBackend:
        service:
          name: defaultService
          port:
            number: 80
    rules:
    - http:
        paths:
        - path: /testpath
          pathType: Prefix
          backend:
            service:
              name: test
              port:
                number: 80
    ```




[1]: https://en.wikipedia.org/wiki/Network_address_translation
[2]: https://kubernetes.io/docs/concepts/services-networking/service/
[3]: https://kubernetes.io/docs/concepts/services-networking/ingress/