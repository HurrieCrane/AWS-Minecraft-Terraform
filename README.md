# AWS-Minecraft-Terraform
A set of terraform scripts for bringing up a minecraft server in AWS using EC2, it uses a _t2.xlarge_ instance. If you want to deploy it then you can either include this is a module in another TF script, or deploy it diretly from this repository. 

There are two prerequisites you'll need to deploy this:
* An AWS account
* A pre-generated PEM to connect to your ec2 instance

## Deployment

There are a few variables that you'll need to pass to the script, or these can be passed to a module, these are part of the small amount of configuration to have to perform, although there are a number of configurable properties (as shown in the configurable properties table)

Start by running Terraform plan:

```bash
terraform plan -var 'create_elastic_ip=<false|true>' -var 'server_name=<server_name>' -var 'minecraft_ec2_pem_name=<name_of_keypair>' -var 'server_ssh_ingress_cidr_blocks=["<ip_range>"]'
```

If that completed successfully then run the apply command:

```bash
terraform apply -var 'create_elastic_ip=<false|true>' -var 'server_name=<server_name>' -var 'minecraft_ec2_pem_name=<name_of_keypair>' -var 'server_ssh_ingress_cidr_blocks=["<ip_range>"]'
```

Once you've deployed all the resources then you can deploy a minecraft server onto the EC2 instance, then it should be all ready to go. However, once the instance is terminated you'll lose the world so make sure to __create a back-up__. 

I'll hopefully work on creating automatic backup and deploying the minecraft server application on to it.

# Configurable properties

Property name | Default value | Description | Required
------------ | ---- | ------------ | ------------- 
server_name | N/A | The name of the minecraft server, used in the tags | ✅
create_elastic_ip | N/A | If true an elastic IP will be created along with the EC2 instance, if false then a then EC2 will automatically be assigned a public IPv4 address | ✅
minecraft_server_vpc_cidr_block | 172.31.0.0/25 | The CIDR block of the VPC | ❌
minecraft_server_vpc_subnet_cidr_block | 172.31.0.0/26 | The single subnet inside of the VPC | ❌
minecraft_server_eni_ips | 172.31.0.10 | The IP of the single eni attached to the EC2 instance | ❌
minecraft_server_region | eu-west-1 | The region the server is hosed in | ❌
minecraft_server_vpc_subnet_az | a | The avalibility zone the subnet and EC2 instance is inside of | ❌
server_ssh_ingress_cidr_blocks | N/A  | The CIDR ranges used the allow SSH security group ingress rules | ✅
server_player_connect_ingress_cidr_blocks | ["0.0.0.0/0"] | The CIDR ranges used to access the server over TCP | ❌
minecraft_ec2_pem_name | N/A | The name of the PEM certificate used to SSH into the instance | ✅
ec2_ami_name | ami-04d5cc9b88f9d1d39 | The default Amazon Linux AMI | ❌
ec2_instance_type | t2.xlarge | The type of instance to create | ❌
