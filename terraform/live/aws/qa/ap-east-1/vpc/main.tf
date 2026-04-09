module "vpc" {
  source = "../../../../../modules/vpc"

  name_prefix                = var.name_prefix
  cidr_block                 = var.cidr_block
  public_availability_zones  = var.public_availability_zones
  public_subnet_cidrs        = var.public_subnet_cidrs
  private_availability_zones = var.private_availability_zones
  private_subnet_cidrs       = var.private_subnet_cidrs
  tags                       = var.tags
}
