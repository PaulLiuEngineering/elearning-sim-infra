module "ecs" {
  source = "../../../../../modules/ecs-fargate-service"

  name_prefix           = var.name_prefix
  vpc_id                = var.vpc_id
  subnet_ids            = var.subnet_ids
  alb_security_group_id = var.alb_security_group_id
  target_group_arn      = var.target_group_arn
  app_bucket_arn        = var.app_bucket_arn
  create_service        = var.create_service
  task_definition_arn   = var.task_definition_arn
  container_name        = var.container_name
  container_port        = var.container_port
  desired_count         = var.desired_count
  tags                  = var.tags
}
