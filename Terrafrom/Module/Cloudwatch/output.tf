output "infra_dashboard_name" {
  value = aws_cloudwatch_dashboard.infra_dashboard.dashboard_name
}
output "app_dashboard_name" {
  value = aws_cloudwatch_dashboard.app_dashboard.dashboard_name
}