# Configure Terraform and the AWS provider
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}

# Connect Terraform to AWS in US East (N. Virginia)
provider "aws" {
  region = "us-east-1"
}

# Find the latest Ubuntu 22.04 LTS AMI published by Canonical
data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"]

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

# Create one EC2 instance in the default VPC
resource "aws_instance" "my_server" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t3.micro"

  tags = {
    Name = "Terraform-First-EC2"
  }
}

# Display the EC2 details after creation
output "instance_id" {
  description = "ID of the EC2 instance created by Terraform"
  value       = aws_instance.my_server.id
}

output "public_ip" {
  description = "Public IPv4 address of the EC2 instance"
  value       = aws_instance.my_server.public_ip
}
