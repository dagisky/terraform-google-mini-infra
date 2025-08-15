Minimal Google Cloud startup infra with Terraform

What this sets up
- VPC with public and private subnets, Cloud Router, and Cloud NAT
- Private GKE cluster in the private subnet
- Placeholder Deployment/Service/Ingress to provision a Google Cloud Load Balancer
- Identity Platform (email/password) for auth
- API Gateway using OpenAPI that requires Identity Platform JWTs
- Google Cloud Storage bucket
- Minimal Cloud SQL Postgres instance

Usage
1) Authenticate with gcloud and set project
   gcloud auth application-default login
   gcloud config set project <PROJECT_ID>

2) Create a terraform.tfvars
   project_id = "your-project-id"
   region     = "us-central1"
   location   = "us-central1"
   env        = "dev"

3) Replace in openapi/openapi.yaml
   - REPLACE_WITH_INGRESS_IP with the output ingress_ip once the GKE ingress is ready
   - Replace ${PROJECT_ID} with your actual project id (or use a template step)

4) Init and apply
   terraform init
   terraform apply

Notes
- GKE is private; NAT allows outbound calls (e.g., OpenAI)
- Node pool is preemptible for cost efficiency and uses autoscaling
- Cloud SQL uses small tier db-f1-micro; adjust for production
- API Gateway is regional; consider Cloud CDN and SSL certs for production

