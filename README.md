# k8s-minikube

tested out with minikube in wsl2

## install ingress controller

enable the built-in ingress addon

```sh
minikube addons enable ingress
```

minikube in WSL2/LinuxVM/hardware is failing in corpnet when http proxy exists

❗  Failing to connect to https://registry.k8s.io/ from inside the minikube container
💡  To pull new external images, you may need to configure a proxy: https://minikube.sigs.k8s.io/docs/reference/networking/proxy/
