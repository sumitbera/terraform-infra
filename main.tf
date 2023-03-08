#-------- root/main.tf -------------

module "networking" {
  source           = "./networking"
  vpc_cidr         = local.vpc_cidr
  access_ip        = var.access_ip
  security_groups  = local.security_groups
  private_sn_count = 2
  public_sn_count  = 2
  public_cidrs     = [for i in range(0, 2, 1) : cidrsubnet(local.vpc_cidr, 2, i)]
  private_cidrs    = [for i in range(2, 4, 1) : cidrsubnet(local.vpc_cidr, 2, i)]
}

module "compute" {
  source         = "./compute"
  public_sg      = module.networking.public_sg
  public_subnets = module.networking.public_subnets
  instance_count = 1
  instance_type  = "t2.micro"
  volume_size    = 10
  key_name       = "testaut"
  user_data_path = file("init.sh")
}