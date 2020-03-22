variable "server_name" {}

/* ====== Misc configuration ====== */
variable "create_elastic_ip" {
  type = bool
}

/* ====== VPC and subnet configuration ====== */

# CIDR block allocation for Minecraft VPC
variable "minecraft_server_vpc_cidr_block" {
  default = "172.31.0.0/25"
}

variable "minecraft_server_vpc_subnet_cidr_block" {
  default = "172.31.0.0/26"
}

variable "minecraft_server_eni_ips" {
  default = [
    "172.31.0.10"
  ]
}

variable "minecraft_server_region" {
  default = "eu-west-1"
}

variable "minecraft_server_vpc_subnet_az" {
  default = "a"
}

/* ====== Security group configuration ====== */

variable "server_ssh_ingress_cidr_blocks" {}

variable "server_player_connect_ingress_cidr_blocks" {
  default = [
    "0.0.0.0/0"
  ]
}

/* ====== EC2 instance configuration ====== */

variable "ec2_ami_name" {
  default = "ami-04d5cc9b88f9d1d39"
}

variable "ec2_instance_type" {
  default = "t2.xlarge"
}
