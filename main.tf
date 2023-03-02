#-------- root/main.tf -------------

module "networking" {
  source        = "./networking"
  vpc_cidr      = "10.16.0.0/16"
  public_cidrs  = ["10.16.0.0/18", "10.16.64.0/18"]
  private_cidrs = ["10.16.128.0/18", "10.16.192.0/18"]
}