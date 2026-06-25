aws_region   = "ap-south-1"
environment  = "POC-Test"
project_name = "octa-byte"
vpc_cidr     = "10.0.0.0/16"
public_subnet_cidrs = [
  "10.0.1.0/24",
  "10.0.2.0/24"
]
private_subnet_cidrs = [
  "10.0.3.0/24",
  "10.0.4.0/24"
]
azs = [
  "ap-south-1a",
  "ap-south-1b"
]
db_name     = "appdb"
db_username = "postgres"
db_password = "Password123!"