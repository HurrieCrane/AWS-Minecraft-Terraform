locals {
  full_az     = "${var.minecraft_server_region}${var.minecraft_server_vpc_subnet_az}"
  common_tags = {
    "Application ID"    = "Minecraft - ${var.server_name}"
    "Application Role"  = "Minecraft Server"
  }
}

provider "aws" {
  region = var.minecraft_server_region # Ireland
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
  availability_zone = local.full_az

  tags {
    Name = "Minecraft-Public-Subnet-${local.full_az}"
  }
}

# Security group allowing SSH
resource "aws_security_group" "minecraft_allow_ssh" {
  name          = "Minecraft_Allow_SSH"
  description   = "Allows SSH into the minecraft server from specific IP's"

  vpc_id        = aws_vpc.minecraft_server_vpc.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = var.server_ssh_ingress_cidr_blocks
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "tcp"
    cidr_blocks = [
      "0.0.0.0/0"
    ]
  }

  tags = local.common_tags

}

# Allow connections over the internet
resource "aws_security_group" "minecraft_allow_connect" {
  name          = "Allow TCP"
  description   = "Allows players to connect to minecraft server over the internet"

  vpc_id        = aws_vpc.minecraft_server_vpc.id

  # allow tcp and udp on any port
  ingress {
    from_port = 23
    to_port   = 65535
    protocol  = "-1"
  }

  tags  = local.common_tags

}


