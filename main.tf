provider "aws" {
  version = "~> 2.0"
  region = var.minecraft_server_region
}

locals {
  full_subnet_az     = "${var.minecraft_server_region}${var.minecraft_server_vpc_subnet_az}"
  common_tags = {
    "Application ID"    = "Minecraft - ${var.server_name}"
    "Application Role"  = "Minecraft Server"
  }
}

resource "aws_vpc" "minecraft_server_vpc" {
  cidr_block            = var.minecraft_server_vpc_cidr_block
  instance_tenancy      = "default"

  # Needs a public DNS hostname and access to public DNS
  enable_dns_support    = true
  enable_dns_hostnames  = true

  tags                  = local.common_tags
}

# Single subnet for minecraft server because
# minecraft servers are not distrobuted
resource "aws_subnet" "minecraft_vpc_public_subnet" {
  cidr_block        = var.minecraft_server_vpc_subnet_cidr_block
  vpc_id            = aws_vpc.minecraft_server_vpc.id
  availability_zone = local.full_subnet_az

  tags = {
    Name = "Minecraft-Public-Subnet-${local.full_subnet_az}"
  }
}

# Security group allowing SSH
resource "aws_security_group" "minecraft_allow_ssh" {
  name          = "Minecraft_Allow_SSH"
  description   = "Allows SSH into the minecraft server from specific IPs"

  vpc_id        = aws_vpc.minecraft_server_vpc.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = var.server_ssh_ingress_cidr_blocks
  }

  egress {
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = [
      "0.0.0.0/0"
    ]
  }

  tags = local.common_tags

}

# Allow connections over the internet
resource "aws_security_group" "main" {
  name          = "Allow TCP"
  description   = "Allows players to connect to minecraft server over the internet"

  vpc_id        = aws_vpc.minecraft_server_vpc.id

  # allow tcp and udp on any port
  ingress {
    from_port = 0
    to_port   = 65535
    cidr_blocks = [

    ]
    protocol  = "-1"
  }

  

  tags  = local.common_tags

}

resource "aws_network_acl" "minecraft_network_acl" {
  vpc_id = aws_vpc.minecraft_server_vpc.id

  egress {
    from_port  = 0
    to_port    = 65535

    rule_no    = 100
    protocol   = "tcp"
    action     = "allow"
    cidr_block = "0.0.0.0/0"
  }

  ingress {
    from_port  = 0
    to_port    = 65535

    rule_no    = 100
    protocol   = "tcp"
    action     = "allow"
    cidr_block = "0.0.0.0/0"
  }

  tags = {
    Name = "main"
  }

}

