#-------- root/main.tf -------------

module "networking" {
  source           = "./networking"
  vpc_cidr         = "10.16.0.0/16"
  private_sn_count = 2
  public_sn_count  = 2
  public_cidrs     = [for i in range(0, 2, 1) : cidrsubnet("10.16.0.0/16", 2, i)]
  private_cidrs    = [for i in range(2, 4, 1) : cidrsubnet("10.16.0.0/16", 2, i)]
}