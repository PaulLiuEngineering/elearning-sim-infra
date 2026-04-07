module "rds" {
  source = "../../../../../modules/rds-postgres"

  name_prefix               = var.name_prefix
  vpc_id                    = var.vpc_id
  subnet_ids                = var.private_subnet_ids
  allowed_security_group_id = var.allowed_security_group_id
  db_name                   = var.db_name
  username                  = var.username
  engine_version            = var.engine_version
  instance_class            = var.instance_class
  backup_retention_period   = var.backup_retention_period
  backup_window             = var.backup_window
  deletion_protection       = var.deletion_protection
  tags                      = var.tags
}

resource "aws_ssm_parameter" "db_address" {
  name  = "/lumio-learning/hk/prod/DB_ADDRESS"
  type  = "String"
  value = module.rds.address

  tags = var.tags
}

resource "aws_ssm_parameter" "db_username" {
  name  = "/lumio-learning/hk/prod/DB_USERNAME"
  type  = "String"
  value = module.rds.username

  tags = var.tags
}

resource "aws_ssm_parameter" "db_password" {
  name  = "/lumio-learning/hk/prod/DB_PASSWORD"
  type  = "SecureString"
  value = module.rds.password

  tags = var.tags
}
