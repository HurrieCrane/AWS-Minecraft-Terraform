##############
# VPC/Subnet #
##############

resource "aws_vpc" "minecraft_server_vpc" {
  cidr_block            = var.minecraft_server_vpc_cidr_block
  instance_tenancy      = "default"

  # Needs a public DNS hostname and access to public DNS
  enable_dns_support    = true
  enable_dns_hostnames  = true

  tags                  = local.common_tags
}

# Single subnet for minecraft server because
# minecraft servers are not distributed
resource "aws_subnet" "minecraft_vpc_public_subnet" {
  cidr_block        = var.minecraft_server_vpc_subnet_cidr_block
  vpc_id            = aws_vpc.minecraft_server_vpc.id
  availability_zone = local.full_subnet_az

  tags = merge({Name = "Minecraft-Public-Subnet-${local.full_subnet_az}"}, local.common_tags)
}

###############
# Elastic IPs #
###############

resource "aws_eip" "minecraft_elastic_ip" {
  count = var.create_elastic_ip ? 1:0

  vpc               = true
  instance          = aws_instance.minecraft_server_ec2.id
  depends_on        = [
    aws_internet_gateway.minecraft_internet_gateway
  ]
  tags = local.common_tags
}

################
# Route Tables #
################

resource "aws_route_table" "main" {
  vpc_id = aws_vpc.minecraft_server_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.minecraft_internet_gateway.id
  }

  tags = local.common_tags
}

resource "aws_route_table_association" "main_route_table_subnet_association" {
  subnet_id      = aws_subnet.minecraft_vpc_public_subnet.id
  route_table_id = aws_route_table.main.id
}