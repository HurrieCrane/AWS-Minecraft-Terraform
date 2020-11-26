terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}

provider "aws" {
  region  = var.minecraft_server_region
}

locals {
  full_subnet_az = "${var.minecraft_server_region}${var.minecraft_server_vpc_subnet_az}"
  common_tags    = {
    "Application ID"    = "Minecraft - ${var.server_name}"
    "Application Role"  = "Minecraft Server"
  }
}