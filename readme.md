# Example

`docker run -v $HOME/.kube/config:/.kube/config -e KUBECONFIG=/.kube/config codefresh/kube-helm:master kubectl --help`

# Build different version

* `git clone https://github.com/codefresh-io/kubectl-helm.git`
* `cd kubectl-helm`
* `docker build --build-arg KUBE_VERSION=v1.8.1 HELM_VERSION=v2.7.0 -t my-kubectl-helm .`
