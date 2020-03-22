
resource "aws_internet_gateway" "minecraft_internet_gateway" {
  vpc_id = aws_vpc.minecraft_server_vpc.id

  tags = {
    Name = "Minecraft Server Internet Gateway"
  }
}

resource "aws_network_interface" "minecraft_server_network_interface" {
  subnet_id       = aws_subnet.minecraft_vpc_public_subnet.id
  private_ips     = var.minecraft_server_eni_ips

  security_groups = [
    aws_security_group.minecraft_allow_ssh.id,
    aws_security_group.main.id
  ]

  attachment {
    instance      = aws_instance.minecraft_server_ec2.id
    device_index  = 1
  }
}

resource "aws_route_table" "main" {
  vpc_id = aws_vpc.minecraft_server_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.minecraft_internet_gateway.id
  }

  tags = {
    Name = "main"
  }

}

resource "aws_route_table_association" "main_route_table_subnet_association" {
  subnet_id      = aws_subnet.minecraft_vpc_public_subnet.id
  route_table_id = aws_route_table.main.id
}

resource "aws_eip" "minecraft_elastic_ip" {
  count = var.create_elastic_ip == true ? 1:0

  vpc               = true
  network_interface = aws_network_interface.minecraft_server_network_interface.id
  depends_on        = [
    aws_internet_gateway.minecraft_internet_gateway
  ]
}
