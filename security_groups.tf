###################
# Security Groups #
###################

# Security group allowing SSH
resource "aws_security_group" "minecraft_allow_ssh" {
  name          = "Minecraft_Allow_SSH"
  description   = "Allows SSH into the minecraft server from specific IPs"

  vpc_id        = aws_vpc.minecraft_server_vpc.id

  ingress {
    from_port   = var.allow_ssh == true ? 22:0
    to_port     = var.allow_ssh == true ? 22:0
    protocol    = "tcp"
    cidr_blocks = var.server_ssh_ingress_cidr_blocks
  }

  egress {
    from_port   = 0
    to_port     = 65535
    cidr_blocks = [
      "0.0.0.0/0"
    ]
    protocol    = "tcp"
  }

  tags  = local.common_tags
}

# Allow connections over the internet
resource "aws_security_group" "main" {
  name          = "Allow TCP"
  description   = "Allows players to connect to minecraft server over the internet"

  vpc_id        = aws_vpc.minecraft_server_vpc.id

//  ingress {
//    from_port   = 25556
//    to_port     = 25556
//    cidr_blocks = [
//      "0.0.0.0/0"
//    ]
//    protocol    = "tcp"
//  }
//
//  ingress {
//    from_port   = 25565
//    to_port     = 25565
//    cidr_blocks = [
//      "0.0.0.0/0"
//    ]
//    protocol    = "udp"
//  }

  ingress {
    from_port = 0
    to_port   = 65535
    cidr_blocks = [
      "0.0.0.0/0"
    ]
    protocol  = "tcp"
  }

  egress {
    from_port   = 0
    to_port     = 65535
    cidr_blocks = [
      "0.0.0.0/0"
    ]
    protocol    = "tcp"
  }

  tags  = local.common_tags
}