# Private Docker Hub Authentication

## Problem

Kubernetes could not pull the image from Docker Hub:

Error: ImagePullBackOff

Cause:
- Repository was private.
- Kubernetes had no Docker Hub credentials.

## Solution

1. Generated Docker Hub Personal Access Token.
2. Created imagePullSecret.
3. Referenced imagePullSecret in Pod spec.
4. Successfully pulled private image.

## Command

kubectl create secret docker-registry dockerhub-secret ...
