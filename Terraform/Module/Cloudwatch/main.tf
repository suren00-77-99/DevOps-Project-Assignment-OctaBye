resource "aws_cloudwatch_dashboard" "infra_dashboard" {
  dashboard_name = "${var.vpc_name}-infra-dashboard"
  dashboard_body = jsonencode({
    widgets = [
      {
        type = "metric"
        x = 0
        y = 0
        width = 12
        height = 6
        properties = {
          metrics = [
            [
              "AWS/ECS",
              "CPUUtilization",
              "ClusterName",
              var.ecs_cluster_name,
              "ServiceName",
              var.ecs_service_name
            ]
          ]
          period = 300
          stat = "Average"
          region = "ap-south-1"
          title = "ECS CPU Utilization"
        }
      },

      {
        type = "metric"
        x = 12
        y = 0
        width = 12
        height = 6
        properties = {
          metrics = [
            [
              "AWS/ECS",
              "MemoryUtilization",
              "ClusterName",
              var.ecs_cluster_name,
              "ServiceName",
              var.ecs_service_name
            ]
          ]
          period = 300
          stat = "Average"
          region = "ap-south-1"
          title = "ECS Memory Utilization"
        }
      }
    ]
  })
}

resource "aws_cloudwatch_dashboard" "app_dashboard" {
  dashboard_name = "${var.vpc_name}-app-dashboard"
  dashboard_body = jsonencode({
    widgets = [
      {
        type = "metric"
        width = 12
        height = 6
        properties = {
          metrics = [
            [
              "AWS/ApplicationELB",
              "RequestCount",
              "LoadBalancer",
              var.alb_arn_suffix
            ]
          ]
          stat = "Sum"
          period = 300
          region = "ap-south-1"
          title = "Request Count"
        }
      },

      {
        type = "metric"
        width = 12
        height = 6
        properties = {
          metrics = [
            [
              "AWS/RDS",
              "CPUUtilization",
              "DBInstanceIdentifier",
              var.rds_identifier
            ]
          ]
          stat = "Average"
          period = 300
          region = "ap-south-1"
          title = "RDS CPU"
        }
      }
    ]
  })
}
