#ECS Cluster
resource "aws_ecs_cluster" "this" {
  name = "${var.vpc_name}-cluster"
  tags = merge( var.tags,{Name = "${var.vpc_name}-cluster"})
}

# CloudWatch Log Group
# This collects application logs.
resource "aws_cloudwatch_log_group" "this" {
  name = "/ecs/${var.vpc_name}"
  retention_in_days = 7
}

# Task Execution Role
# ECS needs permission to:
# Pull images from ECR
# Push logs to CloudWatch

resource "aws_iam_role" "ecs_task_execution_role" {
  name = "${var.vpc_name}-ecs-task-execution-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        }
      }
    ]
  })
}

# Attach AWS managed policy:

resource "aws_iam_role_policy_attachment" "this" {
  role = aws_iam_role.ecs_task_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

# Task Definition
# This is the most important resource.

resource "aws_ecs_task_definition" "this" {
  family = "${var.vpc_name}-task"
  network_mode = "awsvpc"
  requires_compatibilities = [
    "FARGATE"
  ]
  cpu = 256                        # 256 in cpu unite. 256cpuunit = 0.25vcpu, 512 = 0.51vcpu
  memory = 512                    # 512 MB = 0.5gb , 1024 MB = 1GB ### for 256 cpu unit the give memory is good we can give upto 2GB.
  execution_role_arn = aws_iam_role.ecs_task_execution_role.arn
  container_definitions = jsonencode([
    {
      name = "app"
      image = "${var.repository_url}:latest"
      essential = true
      portMappings = [
        {
          containerPort = 8080
          hostPort = 8080
        }
      ]
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          awslogs-group = aws_cloudwatch_log_group.this.name
          awslogs-region = var.aws_region
          awslogs-stream-prefix = "ecs"
        }
      }
    }
  ])

}

# ECS Service
resource "aws_ecs_service" "this" {
  name = "${var.vpc_name}-service"
  cluster = aws_ecs_cluster.this.id
  task_definition = aws_ecs_task_definition.this.arn
  desired_count = 2
  launch_type = "FARGATE"
  network_configuration {
    subnets = var.private_subnet_ids
    security_groups = [
      var.ecs_sg_id
    ]
    assign_public_ip = false
  }
  load_balancer {
    target_group_arn = var.target_group_arn
    container_name = "app"
    container_port = 8080
  }
}