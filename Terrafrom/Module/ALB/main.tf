#Application Load Balancer
resource "aws_lb" "this" {

  name               = "${var.vpc_name}-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups = [
    var.alb_sg_id
  ]

  subnets = var.public_subnet_ids

  tags = merge(var.tags,{Name = "${var.vpc_name}-alb"})
}
#Target Group
#ECS containers will register themselves here.
resource "aws_lb_target_group" "this" {
  name = "${var.vpc_name}-tg"
  port = 8080
  protocol = "HTTP"
  vpc_id = var.vpc_id
  target_type = "ip"
  health_check {

    enabled = true
    path = "/"
    protocol = "HTTP"
    interval = 30
    timeout = 5
    healthy_threshold = 2
    unhealthy_threshold = 2
    matcher = "200"
  }
  tags = merge(var.tags,{Name = "${var.vpc_name}-tg"})
}
#Listener
#Accepts requests on port 80 and forwards them to ECS.
resource "aws_lb_listener" "this" {
  load_balancer_arn = aws_lb.this.arn
  port = 80
  protocol = "HTTP"
  default_action {
    type = "forward"
    target_group_arn = aws_lb_target_group.this.arn
  }
}