
terraform {
  required_version = ">= 1.5.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

# Obtener la VPC predeterminada
data "aws_vpc" "default" {
  default = true
}

# Obtener las subredes disponibles
data "aws_subnets" "default" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
}

# Buscar Ubuntu 22.04 automáticamente
data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"]

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

# Grupo de seguridad
resource "aws_security_group" "spring_sg" {
  name        = "spring-boot-sg"
  description = "Acceso a Spring Boot y SSH"
  vpc_id      = data.aws_vpc.default.id

  # SSH
  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.ssh_cidr]
  }

  # Aplicacion Spring Boot
  ingress {
    description = "Spring Boot API"
    from_port   = var.app_port
    to_port     = var.app_port
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Salida a Internet
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "Spring-Boot-SG"
    Environment = terraform.workspace
    ManagedBy   = "Terraform"
  }
}

# Instancia EC2
resource "aws_instance" "mi_app_spring" {
  ami                         = data.aws_ami.ubuntu.id
  instance_type               = var.instance_type
  subnet_id                   = data.aws_subnets.default.ids[0]
  vpc_security_group_ids      = [aws_security_group.spring_sg.id]
  associate_public_ip_address = true

  key_name = var.key_name

  tags = {
    Name        = "Spring-Boot-${terraform.workspace}"
    Environment = terraform.workspace
    ManagedBy   = "Terraform"
  }
}
