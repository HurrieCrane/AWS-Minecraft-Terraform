resource "aws_network_acl" "minecraft_network_acl" {
  vpc_id = aws_vpc.minecraft_server_vpc.id
  tags   = local.common_tags
}

resource "aws_default_network_acl" "default_network_acl" {
  default_network_acl_id = aws_vpc.minecraft_server_vpc.default_network_acl_id

  egress {
    from_port  = 0
    to_port    = 65535

    rule_no    = 100
    protocol   = "tcp"
    action     = "allow"
    cidr_block = "0.0.0.0/0"
  }

  ingress {
    from_port  = 0
    to_port    = 65535

    rule_no    = 100
    protocol   = "tcp"
    action     = "allow"
    cidr_block = "0.0.0.0/0"
  }

  tags = local.common_tags
}

//resource "aws_network_acl_rule" "minecraft_ssh_tcp_ingress" {
//  network_acl_id = aws_network_acl.minecraft_network_acl.id
//
//  rule_number = 101
//  protocol    = "tcp"
//  rule_action = "allow"
//  from_port   = 22
//  to_port     = 22
//  egress      = false
//  cidr_block  = var.server_ssh_ingress_cidr_blocks[0]
//}
//
//resource "aws_network_acl_rule" "minecraft_pc_tcp_ingress" {
//  network_acl_id = aws_network_acl.minecraft_network_acl.id
//
//  rule_number = 102
//  protocol    = "tcp"
//  rule_action = "allow"
//  from_port   = 25556
//  to_port     = 25556
//  egress      = false
//  cidr_block  = "0.0.0.0/0"
//}
//
//resource "aws_network_acl_rule" "minecraft_pc_udp_ingress_single_port" {
//  network_acl_id = aws_network_acl.minecraft_network_acl.id
//
//  rule_number = 103
//  protocol    = "udp"
//  rule_action = "allow"
//  from_port   = 25565
//  to_port     = 25565
//  egress      = false
//  cidr_block  = "0.0.0.0/0"
//}
//
//resource "aws_network_acl_rule" "minecraft_pc_tcp_egress" {
//  network_acl_id = aws_network_acl.minecraft_network_acl.id
//
//  rule_number = 100
//  protocol    = "tcp"
//  rule_action = "allow"
//  from_port   = 0
//  to_port     = 65535
//  egress      = true
//  cidr_block  = "0.0.0.0/0"
//}