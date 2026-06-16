resource "aws_db_subnet_group" "this" {
  name       = "rds-${vpc_name}-subnet-group"
  subnet_ids = var.private_subnet_ids

  tags = {
    Name = "rds-${vpc_name}-subnet-group"
  }
}

resource "aws_db_instance" "this" {
  identifier             = "rds-${vpc_name}-postgres"

  engine                 = "postgres"
  engine_version         = "16"
  instance_class         = "db.t3.micro"

  allocated_storage      = 20
  storage_type           = "gp2"

  db_name                = "appdb"
  username               = "postgres"
  password               = var.password

  db_subnet_group_name   = aws_db_subnet_group.this.name

  vpc_security_group_ids = [var.rds_sg_id]

  publicly_accessible    = false
  multi_az               = false

  skip_final_snapshot    = true

  backup_retention_period = 0

  tags = {
    Name = "rds-${vpc_name}"
  }
}