## Create a private key
resource "tls_private_key" "ec2" {
  algorithm = var.tls_private_key_algorithm
  rsa_bits  = var.tls_private_key_rsa_bits
}

## Create a key pair
resource "aws_key_pair" "default" {
  key_name   = var.name
  public_key = tls_private_key.ec2.public_key_openssh
}

## Calling the EC2 module
module "ec2" {
  source                  = "./modules/ec2"
  ec2_instance_name       = "ec2-instance-${var.stage}"
  ec2_instance_type       = "t2.micro"
  ami_id                  = "ami-04cbc90abb08f0321"
  ec2_security_group_name = "ec2-sg-${var.stage}"
  vpc_id                  = module.vpc.vpc_id
  vpc_cidr                = module.vpc.vpc_cidr
  subnet_id               = module.vpc.public_subnets[0]
  key_name                = aws_key_pair.default.key_name
  stage                   = var.stage
}


## Create a Secrets Manager secret for the EC2 key pair
resource "aws_secretsmanager_secret" "ec2_key_pair" {
  name                    = "${var.name}/${var.stage}/ec2_key_pair"
  recovery_window_in_days = 0
}

## Create a Secrets Manager secret version and store the private key
resource "aws_secretsmanager_secret_version" "ec2_key_pair_json" {
  secret_id = aws_secretsmanager_secret.ec2_key_pair.id
  secret_string = jsonencode({
    "private_key" : tls_private_key.ec2.private_key_pem
    "public_key" : tls_private_key.ec2.public_key_pem
  })
}
