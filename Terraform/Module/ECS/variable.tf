variable "vpc_name" {
    type = string
}
variable "aws_region" {
  type = string
}
variable "private_subnet_ids" {
  type = list(string)
}
variable "ecs_sg_id" {
  type = string
}
variable "target_group_arn" {
  type = string
}
variable "repository_url" {
  type = string
}
variable "tags" {
  type = map(string)
}