# KCL Demo

This repository demonstrates the use of [KCL (Kubernetes Configuration Language)](https://kcl-lang.io/) to manage Kubernetes configurations efficiently. The demo sets up a local Kubernetes cluster using `kind`, deploys a sample log generator application, and showcases how KCL simplifies Kubernetes resource creation.

## Repository Structure

```bash
.
├── LICENSE                  # License file for the project
├── README.md                # Documentation for the repository
├── Taskfile.yaml            # Taskfile for creation of local cluster
├── app                      # Application directory
│   ├── Dockerfile           # Dockerfile for building the application container
│   ├── Taskfile.yaml        # Taskfile for building the app
│   ├── go.mod               # Go module dependencies
│   ├── go.sum               # Go module lock file
│   └── main.go              # Main Go application source code
├── kind-config.yaml         # Configuration file for creating a kind cluster
└── log-generator            # KCL configurations for Kubernetes resources
    ├── deployment.k         # KCL schema for Deployment
    ├── hpa.k                # KCL schema for HorizontalPodAutoscaler
    ├── ingress.k            # KCL schema for Ingress
    ├── kcl.mod              # KCL module configuration
    ├── kcl.mod.lock         # KCL module lock file
    ├── main.k               # Main KCL script to orchestrate resources
    ├── namespace.k          # KCL schema for Namespace
    ├── secret.k             # KCL schema for Secret
    └── service.k            # KCL schema for Service
```

## Prerequisites

- [KCL](https://www.kcl-lang.io)
- [Docker](https://www.docker.com/products/docker-desktop/)
- [kind](https://kind.sigs.k8s.io)
- [Task](https://taskfile.dev)

### Installation and Usage

Follow these steps to set up the demo:

#### Clone the Repository

```bash
git clone https://github.com/NoNickeD/kcl-demo.git

cd kcl-demo
```

#### Deploy the Local Kind Cluster

```bash
task full-deploy-local
```

#### Build and Deploy the Application

1. Navigate to the application directory:

```bash
cd ./app
```

2. Build the application container locally:

```bash
task build-local
```

Note the name and tag of the generated image.

3. Return to the `log-generator` directory to generate Kubernetes manifests:

```bash
cd ../log-generator/
```

4. Generate the Kubernetes configuration using KCL:

```bash
# Use your image from the previous output.
kcl run main.k -D 'params={"image": "ttl.sh/1a06308c-81c4-4454-8f31-1e91d4918736:2h", "replicas": 3}' > resources.yaml
```

5. Convert the generated `resources.yaml` to a valid Kubernetes manifest:

```bash
awk '/^resources:/ {next} /^- apiVersion:/ {if (NR > 1) print "---"} {sub(/^- /, ""); gsub(/^  /, ""); print}' resources.yaml > log-generator.yaml
```

6. Apply the manifest to the cluster:

```bash
kubectl apply --filename log-generator.yaml
```

## Verify the Deployment

Use the following commands to verify the deployed resources:

```bash
kubectl get namespaces

kubectl --namespace sre-log-generator get deployments

kubectl --namespace sre-log-generator get secrets

kubectl --namespace sre-log-generator get hpa

kubectl --namespace sre-log-generator get service

kubectl --namespace sre-log-generator get ingress
```

## Clean Up

To delete the local kind cluster, run:

```bash
cd ../

task delete-local-cluster
```

## Key Features of the Demo

- **KCL for Kubernetes:** Simplifies Kubernetes resource definitions using schema validation, modularity, and dynamic parameters.
- **Local Kind Cluster:** Uses kind to create a local Kubernetes cluster for testing.
- **Task Automation:** Leverages Taskfile for streamlined workflows.
- **Dynamic Resource Generation:** Demonstrates how to use KCL with dynamic parameters for image and replica counts.

![KCL Demo](/images/kcldemo.gif)
