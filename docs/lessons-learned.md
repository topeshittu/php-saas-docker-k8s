# Lessons Learned

## Project Overview

This project started as a Docker containerization exercise for a PHP SaaS application and evolved into a complete container deployment workflow involving Docker Hub and Kubernetes.

The goal was not only to containerize the application but also to understand how modern cloud-native applications are deployed, managed, and scaled.

---

## Key Lessons Learned

### 1. Docker and Kubernetes Solve Different Problems

One of the biggest lessons learned was understanding the difference between Docker and Kubernetes.

Docker is responsible for packaging and running applications in containers.

Kubernetes is responsible for managing and orchestrating those containers at scale.

A Docker container can run successfully on its own, but Kubernetes provides:

* Automated deployment
* Scaling
* Self-healing
* Service discovery
* High availability

---

### 2. Container Images Must Be Properly Tagged

A container image can exist locally but still be unavailable to Kubernetes if it is not tagged correctly.

For example:

```bash
docker tag postifyhq-app topeshittu/postifyhq:v1
docker push topeshittu/postifyhq:v1
```

Kubernetes requires the full image reference:

```yaml
image: topeshittu/postifyhq:v1
```

Using only:

```yaml
image: postifyhq
```

caused image pull failures.

---

### 3. Private Container Registries Require Authentication

When the Docker Hub repository was changed from public to private, Kubernetes could no longer pull the image.

The deployment failed with:

```text
ErrImagePull
ImagePullBackOff
```

The issue was resolved by:

1. Creating a Docker Hub Personal Access Token.
2. Creating a Kubernetes ImagePullSecret.
3. Referencing the secret inside the Pod specification.

This demonstrated how Kubernetes authenticates against private container registries.

---

### 4. Pods Are Not Usually Managed Directly

A Pod can be created manually, but Pods are generally managed through higher-level Kubernetes resources.

The recommended approach is:

```text
Deployment
    ↓
ReplicaSet
    ↓
Pods
```

The Deployment ensures that the desired number of Pods is always running.

---

### 5. ReplicaSets Provide Self-Healing

ReplicaSets monitor the number of running Pods.

If a Pod is deleted or crashes, Kubernetes automatically creates a replacement.

This introduces the concept of desired state management.

Instead of manually restarting applications, Kubernetes continuously works to maintain the declared state.

---

### 6. Deployments Simplify Application Management

Deployments provide additional features on top of ReplicaSets.

Benefits include:

* Scaling
* Rolling updates
* Rollbacks
* Version management

Creating a Deployment with three replicas automatically created:

* One Deployment
* One ReplicaSet
* Three Pods

without any manual intervention.

---

### 7. Port Forwarding Is Extremely Useful

Kubernetes applications can be accessed without creating Services by using:

```bash
kubectl port-forward
```

Example:

```bash
kubectl port-forward pod/postifyhq 8081:80
```

This forwards local traffic to a running Pod and is extremely useful for testing and troubleshooting.

---

### 8. Kubernetes Does Not Need Exclusive Access To Port 80

A container can listen on port 80 internally while the host machine uses completely different ports.

Example:

```text
Docker Container
localhost:8080 → container:80

Kubernetes Pod
localhost:8081 → pod:80
```

This demonstrated the difference between host ports and container ports.

---

### 9. Minimal Container Images Often Lack Troubleshooting Tools

While troubleshooting inside containers, common Linux utilities such as:

* netstat
* ss
* ping

were unavailable.

Instead, troubleshooting relied on:

```bash
kubectl logs
kubectl exec
ps aux
kubectl describe
```

This highlighted the importance of understanding Kubernetes-native debugging techniques.

---

### 10. YAML Generation Using Dry Run Saves Time

Using:

```bash
kubectl create deployment \
  --dry-run=client \
  -o yaml
```

proved to be one of the fastest ways to generate Kubernetes manifests.

This approach reduces manual YAML writing and helps prevent syntax errors.

---

## Skills Acquired

Through this project, the following practical skills were developed:

* Docker image creation
* Docker image tagging
* Docker Hub usage
* Private registry authentication
* Kubernetes Pods
* ReplicaSets
* Deployments
* ImagePullSecrets
* Port Forwarding
* Kubernetes Networking Fundamentals
* YAML Manifest Creation
* Kubernetes Troubleshooting
* Container Orchestration Concepts

---

## Final Thoughts

This project provided hands-on experience with the complete lifecycle of modern containerized application deployment.

The workflow progressed from:

```text
Application
    ↓
Docker Image
    ↓
Docker Hub
    ↓
Private Registry Authentication
    ↓
Kubernetes Pod
    ↓
Deployment
    ↓
ReplicaSet
    ↓
Multiple Running Pods
```

Most importantly, the project transformed theoretical Kubernetes concepts into practical experience through building, deploying, troubleshooting, scaling, and managing a real application in a Kubernetes environment.

