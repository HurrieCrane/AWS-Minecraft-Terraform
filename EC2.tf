
# Actual EC2 instance
resource "aws_instance" "minecraft_server_ec2" {
  ami           = var.ec2_ami_name
  instance_type = var.ec2_instance_type

  subnet_id     = aws_subnet.minecraft_vpc_public_subnet.id

  security_groups = [
    aws_security_group.minecraft_allow_ssh.id,
    aws_security_group.minecraft_allow_connect.id
  ]

  depends_on = [ "aws_internet_gateway.minecraft_internet_gateway" ]

  associate_public_ip_address = !var.create_elastic_ip

  tags = local.common_tags

}

resource "aws_network_interface" "minecraft_server_network_interface" {
  subnet_id       = aws_subnet.minecraft_vpc_public_subnet.id
  private_ips     = [var.minecraft_server_eni_ips]

  security_groups = [
    aws_security_group.minecraft_allow_ssh,
    aws_security_group.minecraft_allow_connect
  ]

  attachment {
    instance = aws_instance.minecraft_server_ec2.id
    device_index = 0
  }
}

resource "aws_internet_gateway" "minecraft_internet_gateway" {
  vpc_id = aws_vpc.minecraft_server_vpc.id

  tags {
    Name = "Minecraft Internet Gateway"
  }
}

resource "aws_route_table" "minecraft_route_table" {
  vpc_id = aws_vpc.minecraft_server_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.minecraft_internet_gateway.id
  }

  tags {
    Name = "main"
  }

}

