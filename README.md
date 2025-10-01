# DevOps / Cloud Engineers Assessment: Scalable Web Service Deployment

This repository contains the solution for the DevOps / Cloud Engineers Assessment. It provides a complete framework for deploying a scalable, highly available, and observable web service on AWS using modern DevOps practices.

## Table of Contents

- [Architectural Design](#architectural-design)
  - [Assumptions](#assumptions)
  - [Core Components](#core-components)
  - [Networking](#networking)
  - [Scalability and High Availability](#scalability-and-high-availability)
  - [Security](#security)
  - [Disaster Recovery](#disaster-recovery)
- [Infrastructure as Code (IaC)](#infrastructure-as-code-iac)
  - [Terraform Structure](#terraform-structure)
- [Implementation Details](#implementation-details)
  - [Sample Application](#sample-application)
  - [Dockerization](#dockerization)
  - [Kubernetes Manifests](#kubernetes-manifests)
- [Monitoring and Observability](#monitoring-and-observability)
- [CI/CD Pipeline](#cicd-pipeline)
- [How to Deploy](#how-to-deploy)
- [Technology Choices](#technology-choices)

## Architectural Design

The architecture is designed to be robust, scalable, and resilient, leveraging the power of AWS and Kubernetes.

![Architecture Diagram](https://user-images.githubusercontent.com/1234567/123456789-abcdef.png)  <!-- Placeholder for a diagram -->

### Assumptions

- **Containerized Service:** The web service is delivered as a Docker container.
- **Stateless Application:** The application is stateless, allowing for flexible scaling and replacement of pods. Any state is managed by external services (e.g., a managed database).
- **Health Checks:** The container exposes `/healthz` and `/readyz` endpoints for liveness and readiness probes.
- **Graceful Shutdown:** The application can handle `SIGTERM` signals to shut down gracefully, finishing in-flight requests before exiting.

### Core Components

- **Amazon EKS (Elastic Kubernetes Service):** A managed Kubernetes service that simplifies the deployment and management of containerized applications.
- **AWS Fargate (Optional, for context):** While we use EC2-based nodes for more control, Fargate is a serverless option for running containers without managing servers.
- **Application Load Balancer (ALB):** Distributes incoming traffic across multiple targets and integrates seamlessly with EKS via the AWS Load Balancer Controller.
- **Amazon ECR (Elastic Container Registry):** A secure and scalable Docker image registry.
- **Amazon CloudWatch:** Used for logging, monitoring, and alarms.

### Networking

- **VPC:** A dedicated Virtual Private Cloud (VPC) isolates the application's network environment.
- **Subnets:** The VPC is divided into public and private subnets across multiple Availability Zones (AZs) for high availability.
  - **Public Subnets:** ALBs and NAT Gateways reside here.
  - **Private Subnets:** EKS worker nodes and application pods run here to protect them from direct internet access.
- **NAT Gateway:** Allows services in private subnets to access the internet for external dependencies (e.g., pulling base Docker images) without being publicly exposed.

### Scalability and High Availability

- **Horizontal Pod Autoscaler (HPA):** Automatically scales the number of application pods based on CPU or memory utilization.
- **Cluster Autoscaler:** Automatically adjusts the number of EKS worker nodes to meet the demands of the cluster.
- **Multi-AZ Deployment:** The infrastructure is deployed across at least two AZs to ensure resilience against single-AZ failures.

### Security

- **IAM Roles for Service Accounts (IRSA):** Provides fine-grained permission control for pods to access AWS services.
- **Security Groups:** Act as virtual firewalls to control traffic to and from EC2 instances and ALBs.
- **Network Policies:** Kubernetes network policies can be used to control traffic flow between pods inside the cluster.

### Disaster Recovery

- **Immutable Infrastructure:** The entire infrastructure is defined as code, allowing for rapid and consistent recreation in another region if needed.
- **Automated Backups:** While not in the scope of this initial setup, stateful components like databases would have automated backups and point-in-time recovery enabled.

## Infrastructure as Code (IaC)

The infrastructure is provisioned using Terraform, ensuring a repeatable and version-controlled setup.

### Terraform Structure

The Terraform code is organized into modules for clarity and reusability:

```
terraform/
├── main.tf         # Main entrypoint
├── variables.tf    # Input variables
├── outputs.tf      # Outputs
├── providers.tf    # AWS provider configuration
└── modules/
    ├── vpc/        # VPC, subnets, NAT Gateway
    └── eks/        # EKS cluster and node groups
```

## Implementation Details

### Sample Application

A simple Python FastAPI application is provided in the `app/` directory. It includes:
- `main.py`: The main application logic.
- `requirements.txt`: Python dependencies.
- Health check endpoints (`/healthz`, `/readyz`).

### Dockerization

A `Dockerfile` is provided to containerize the application. It uses a multi-stage build to create a small, optimized production image. A `.dockerignore` file is included to prevent unnecessary files from being copied into the build context.

### Kubernetes Manifests

The `kubernetes/` directory contains the necessary manifests for deploying the application:
- `deployment.yaml`: Defines the desired state for the application pods.
- `service.yaml`: Creates a stable endpoint for accessing the application within the cluster.
- `ingress.yaml`: Configures the ALB to route external traffic to the service.
- `hpa.yaml`: Configures the HPA to scale the deployment.

## Monitoring and Observability

The architecture includes a robust monitoring and observability setup, crucial for maintaining a reliable service.

### Application Metrics with Prometheus

The sample application is instrumented to expose a `/metrics` endpoint, which provides key performance indicators (e.g., request latency, counts, and errors). These metrics are scraped by Prometheus.

**Setup Instructions:**

1.  **Install the Prometheus Operator:** This is the recommended way to deploy and manage Prometheus on Kubernetes.
    ```bash
    kubectl create -f https://raw.githubusercontent.com/prometheus-operator/prometheus-operator/v0.58.0/bundle.yaml
    ```

2.  **Verify the Installation:** Ensure the Prometheus Operator pods are running in the `default` namespace (or your chosen namespace).

The `service.yaml` manifest is already annotated (`prometheus.io/scrape: "true"`) to allow Prometheus to automatically discover and scrape the application's metrics endpoint.

### Visualization with Grafana

Grafana can be used to create dashboards to visualize the metrics collected by Prometheus.

**Setup Instructions:**

1.  **Install Grafana:**
    ```bash
    kubectl apply -f https://raw.githubusercontent.com/grafana/grafana/master/deployment/kubernetes/grafana-deployment.yaml
    kubectl apply -f https://raw.githubusercontent.com/grafana/grafana/master/deployment/kubernetes/grafana-service.yaml
    ```

2.  **Access Grafana:**
    ```bash
    kubectl port-forward svc/grafana 3000:3000
    ```
    You can then access Grafana at `http://localhost:3000`. The default credentials are `admin`/`admin`.

3.  **Add Prometheus as a Data Source:** Configure Grafana to use your Prometheus server as a data source.

### Centralized Logging with CloudWatch

By default, an EKS cluster is configured to forward container logs from all pods to Amazon CloudWatch Logs.

**How to View Logs:**

1.  Navigate to the **CloudWatch** service in the AWS Console.
2.  Go to **Log groups**.
3.  Find the log group for your EKS cluster, which will typically be named `/aws/eks/<cluster-name>/cluster`.
4.  Within the log group, you can search and filter logs from different pods and containers. This is invaluable for debugging and monitoring application health.

## CI/CD Pipeline

A GitHub Actions workflow (`.github/workflows/main.yml`) automates the build and deployment process.

### Workflow Steps

1.  **Trigger:** The workflow runs on every push to the `main` branch.
2.  **Authenticate with AWS:** It uses OIDC to securely assume an IAM role in AWS, avoiding the need for long-lived credentials.
3.  **Build & Push to ECR:** It builds the Docker image, tags it with the Git commit SHA, and pushes it to the ECR repository.
4.  **Deploy to EKS:** It updates the Kubernetes deployment manifest with the new image tag and applies all the manifests to the cluster.

### Setting Up GitHub Secrets

To enable the CI/CD pipeline, you must configure the following secrets in your GitHub repository settings (`Settings > Secrets and variables > Actions`):

-   `AWS_REGION`: The AWS region where your infrastructure is deployed (e.g., `us-west-2`).
-   `AWS_IAM_ROLE_TO_ASSUME`: The ARN of the IAM role that GitHub Actions will assume. You need to create this role in your AWS account and establish a trust relationship with GitHub's OIDC provider.
-   `ECR_REPOSITORY_NAME`: The name of the ECR repository created by Terraform (e.g., `scalable-web-service-repo`).
-   `EKS_CLUSTER_NAME`: The name of the EKS cluster (e.g., `scalable-web-service`).

**Note on IAM Role for GitHub Actions:**

You will need to create an IAM role that the GitHub Actions workflow can assume. This role should have policies attached that grant permissions to:
-   Push images to ECR.
-   Describe the EKS cluster (`eks:DescribeCluster`).
-   Update the `kubeconfig` file.
-   Perform actions on the Kubernetes cluster (this is managed via an `aws-auth` ConfigMap in EKS).

## How to Deploy

1. **Prerequisites:**
   - AWS Account
   - Terraform installed
   - `kubectl` installed
   - `aws-cli` installed and configured

2. **Steps:**
   - Clone this repository.
   - Configure your AWS credentials.
   - Initialize and apply the Terraform configuration: `terraform init && terraform apply`.
   - The GitHub Actions pipeline will handle subsequent deployments.

## Technology Choices

- **AWS:** A leading cloud provider with a mature ecosystem of services.
- **Kubernetes (EKS):** The industry standard for container orchestration, offering scalability and a rich feature set.
- **Terraform:** The most popular IaC tool, cloud-agnostic and with a strong community.
- **Docker:** The de-facto standard for containerization.
- **GitHub Actions:** For simple and powerful CI/CD integrated with the source code repository.
- **FastAPI:** A modern, high-performance Python web framework.