# AWS VPC Infrastructure with Terraform

This Terraform project provisions a basic AWS infrastructure including:

- A Virtual Private Cloud (VPC)
- A public subnet
- An internet gateway and routing table
- A security group for common ports
- An EC2 instance
- An S3 bucket
- Remote state storage using S3 backend

---

## 🧰 Components Created

| Component            | Description                                      |
|----------------------|--------------------------------------------------|
| VPC                  | Custom VPC with CIDR block `10.0.0.0/21`         |
| Subnet               | Public subnet in `eu-north-1a`                   |
| Internet Gateway     | Allows outbound internet traffic                 |
| Route Table          | Routes traffic to the internet gateway           |
| Route Association    | Associates subnet with the route table           |
| Security Group       | Allows SSH (22), HTTP (80), HTTPS (443) access  |
| EC2 Instance         | `t3.micro` instance with a public IP             |
| S3 Bucket            | For remote state and general object storage      |

---

## 🧾 Backend Configuration

Terraform state is stored remotely in an S3 bucket:

```hcl
terraform {
  backend "s3" {
    bucket = "myterraforms3bucketcloud"
    key    = "state/terraform.tfstate"
    region = "eu-north-1"
  }
}

✅ Prerequisites
An AWS account
AWS CLI configured (aws configure)
Terraform installed (terraform -v)
IAM permissions to create VPCs, EC2, S3, etc.

📂 Folder Structure
.
├── main.tf          # Main Terraform configuration
├── README.md        # Project documentation

📌 Notes
Make sure the S3 bucket already exists before running terraform init.
Replace the hardcoded AMI ID (ami-09278528675a8d54e) with a valid one if needed.
