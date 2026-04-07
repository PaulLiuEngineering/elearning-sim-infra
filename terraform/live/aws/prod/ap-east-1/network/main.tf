module "private_subnets" {
  source = "../../../../../modules/private-subnets"

  name_prefix          = var.name_prefix
  vpc_id               = var.vpc_id
  availability_zones   = var.availability_zones
  private_subnet_cidrs = var.private_subnet_cidrs
  tags                 = var.tags
}
