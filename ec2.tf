resource "aws_instance" "minecraft_server_ec2" {
  ami           = var.ec2_ami_name
  instance_type = var.ec2_instance_type

  subnet_id     = aws_subnet.minecraft_vpc_public_subnet.id

  vpc_security_group_ids = [
    aws_security_group.minecraft_allow_ssh.id,
    aws_security_group.main.id
  ]

  depends_on = [
    aws_internet_gateway.minecraft_internet_gateway
  ]

  associate_public_ip_address = !var.create_elastic_ip
  root_block_device {
    volume_type           = "standard"
    volume_size           = "8" # 8GB
    delete_on_termination = true
  }

  key_name = var.minecraft_ec2_pem_name
  tags     = local.common_tags
}