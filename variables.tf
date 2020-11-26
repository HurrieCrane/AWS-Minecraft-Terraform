variable "server_name" {}

/* ====== Misc configuration ====== */
variable "create_elastic_ip" {
  type = bool
}
variable "allow_ssh" {
  type    = bool
  default = true
}

/* ====== VPC and subnet configuration ====== */

# CIDR block allocation for Minecraft VPC
variable "minecraft_server_vpc_cidr_block" {
  default = "172.31.0.0/25"
  type    = string
}

variable "minecraft_server_vpc_subnet_cidr_block" {
  type    = string
  default = "172.31.0.0/26"
}

variable "minecraft_server_eni_ips" {
  type    = list(string)
  default = [
    "172.31.0.10"
  ]
}

variable "minecraft_server_region" {
  type    = string
  default = "eu-west-1" # Ireland
}

variable "minecraft_server_vpc_subnet_az" {
  type    = string
  default = "a"
}

/* ====== Security group configuration ====== */

variable "server_ssh_ingress_cidr_blocks" {
  type = list(string)
}

variable "server_player_connect_ingress_cidr_blocks" {
  type    = list(string)
  default = [
    "0.0.0.0/0"
  ]
}

/* ====== EC2 instance configuration ====== */

variable "minecraft_ec2_pem_name" {
  type = string
}

variable "ec2_ami_name" {
  default = "ami-04d5cc9b88f9d1d39"
}

variable "ec2_instance_type" {
  default = "t3.large" # "r5a.large" # "t2.xlarge"
}
