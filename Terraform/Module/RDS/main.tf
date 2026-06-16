resource "aws_db_subnet_group" "this" {
  name = "rds-${var.vpc_name}-db-subnet-group"
  subnet_ids = var.private_subnet_ids
  tags = merge(var.tags,{Name = "rds-${var.vpc_name}-db-subnet-group"})

}

#DB instance
resource "aws_db_instance" "this" {
  identifier =  "rds-${var.vpc_name}-postgres"
  engine = "postgres"
  engine_version = "16.3"
  instance_class = "db.t3.micro"
  allocated_storage = 20
  storage_type = "gp3"
  db_name = var.db_name
  username = var.username
  password = var.password
  skip_final_snapshot = true
  publicly_accessible = false
  multi_az = false
  db_subnet_group_name = aws_db_subnet_group.this.name
  vpc_security_group_ids = [
    var.rds_sg_id
  ]
  backup_retention_period = 7
  deletion_protection = false
  tags = merge(var.tags,{Name = "rds-${var.vpc_name}-postgres"})
}