data "aws_caller_identity" "this" {}
data "aws_region" "this" {}

locals {
  common_tags = {
    "Terraform" = true
    "Environment" = var.environment
  }

  tags = merge(var.tags, local.common_tags)
}

resource "aws_security_group" "rest" {
  name = "${var.name}-rest"
  vpc_id = var.vpc_id
  description = "Security group for rest api on p rep nodes"

  tags = local.tags
}

resource "aws_security_group_rule" "rest_egress" {
  type = "egress"
  security_group_id = aws_security_group.rest.id
  from_port = 0
  to_port = 0
  protocol = "-1"
  cidr_blocks = [
    "0.0.0.0/0"]
}

resource "aws_security_group" "grpc" {
  name = "${var.name}-grpc"
  vpc_id = var.vpc_id
  description = "Security group for grpc communication on p rep nodes"

  tags = local.tags
}

resource "aws_security_group_rule" "grpc_egress" {
  type = "egress"
  security_group_id = aws_security_group.grpc.id
  from_port = 0
  to_port = 0
  protocol = "-1"
  cidr_blocks = [
    "0.0.0.0/0"]
}

resource "aws_security_group_rule" "ssh_ingress" {
  count = var.corporate_ip == "" ? 0 : 1

  type = "ingress"
  security_group_id = aws_security_group.grpc.id
  cidr_blocks = [
    "${var.corporate_ip}/32"]
  from_port = 22
  to_port = 22
  protocol = "tcp"
}

resource "aws_security_group_rule" "testing_ssh_ingress" {
  count = var.corporate_ip == "" ? 1 : 0

  type = "ingress"
  security_group_id = aws_security_group.grpc.id
  cidr_blocks = [
    "0.0.0.0/0"]
  from_port = 22
  to_port = 22
  protocol = "tcp"
}

resource "aws_security_group_rule" "rest_ingress" {
  type = "ingress"
  security_group_id = aws_security_group.rest.id
  cidr_blocks = [
    "0.0.0.0/0"]
  from_port = 9000
  to_port = 9000
  protocol = "tcp"
}

resource "aws_security_group_rule" "grpc_ingress" {
  type = "ingress"
  security_group_id = aws_security_group.grpc.id
  cidr_blocks = [
    "0.0.0.0/0"]
  from_port = 7100
  to_port = 7100
  protocol = "tcp"
}

resource "aws_security_group_rule" "host_metrics_ingress" {
  type = "ingress"
  security_group_id = aws_security_group.grpc.id
  cidr_blocks = [
    "10.0.0.0/15"]
  from_port = 9100
  to_port = 9100
  protocol = "tcp"
}

resource "aws_security_group_rule" "docker_metrics_ingress" {
  type = "ingress"
  security_group_id = aws_security_group.grpc.id
  cidr_blocks = [
    "10.0.0.0/15"]
  from_port = 9323
  to_port = 9323
  protocol = "tcp"
}
