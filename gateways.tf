####################
# Internet Gateway #
####################

resource "aws_internet_gateway" "minecraft_internet_gateway" {
  vpc_id = aws_vpc.minecraft_server_vpc.id
  tags = local.common_tags
}

#######
# ENI #
#######

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

  tags = local.common_tags
}