module "rds" {
  source = "../rds-postgres"

  name_prefix                = var.name_prefix
  vpc_id                     = var.vpc_id
  subnet_ids                 = var.subnet_ids
  allowed_security_group_id  = var.allowed_security_group_id
  allowed_security_group_ids = var.allowed_security_group_ids
  db_name                    = var.db_name
  username                   = var.username
  engine_version             = var.engine_version
  instance_class             = var.instance_class
  allocated_storage          = var.allocated_storage
  max_allocated_storage      = var.max_allocated_storage
  backup_retention_period    = var.backup_retention_period
  backup_window              = var.backup_window
  deletion_protection        = var.deletion_protection
  tags                       = var.tags
}

resource "aws_ssm_parameter" "db_address" {
  count = var.db_address_ssm_parameter_name == null ? 0 : 1

  name  = var.db_address_ssm_parameter_name
  type  = "String"
  value = module.rds.address
  tags  = var.tags
}

resource "aws_ssm_parameter" "db_username" {
  count = var.db_username_ssm_parameter_name == null ? 0 : 1

  name  = var.db_username_ssm_parameter_name
  type  = "String"
  value = module.rds.username
  tags  = var.tags
}

resource "aws_ssm_parameter" "db_password" {
  count = var.db_password_ssm_parameter_name == null ? 0 : 1

  name  = var.db_password_ssm_parameter_name
  type  = "SecureString"
  value = module.rds.password
  tags  = var.tags
}
