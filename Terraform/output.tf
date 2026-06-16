output "vpc_id" {
  value = module.vpc.vpc_id
}
output "alb_dns_name" {
  value = module.alb.alb_dns_name
}
output "repository_url" {
  value = module.ecr.repository_url
}
output "cluster_name" {
  value = module.ecs.cluster_name
}
output "service_name" {
  value = module.ecs.service_name
}
output "db_endpoint" {
  value = module.rds.db_endpoint
}