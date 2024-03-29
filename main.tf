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

resource "aws_security_group_rule" "bastion_ssh_ingress" {
  count = var.bastion_security_group == "" ? 0 : 1

  type = "ingress"
  security_group_id = aws_security_group.grpc.id
  from_port = 22
  to_port = 22
  protocol = "tcp"
  source_security_group_id = var.bastion_security_group
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

resource "aws_security_group_rule" "rest_ingress_standalone" {
  count = var.citizen_security_group_id == "" ? 1 : 0

  type = "ingress"
  security_group_id = aws_security_group.rest.id
  from_port = 9000
  to_port = 9000
  protocol = "tcp"

  cidr_blocks = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "rest_ingress_cluster" {
  count = var.citizen_security_group_id == "" ? 0 : 1

  type = "ingress"
  security_group_id = aws_security_group.rest.id
  from_port = 9000
  to_port = 9000
  protocol = "tcp"

  source_security_group_id = var.citizen_security_group_id
}


resource "aws_security_group_rule" "grpc_ingress_standalone" {
  count = var.sentry_security_group_id == "" ? 1 : 0

  type = "ingress"
  security_group_id = aws_security_group.grpc.id
  from_port = 7100
  to_port = 7100
  protocol = "tcp"

  cidr_blocks = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "grpc_ingress_cluster" {
  count = var.sentry_security_group_id == "" ? 0 : 1

  type = "ingress"
  security_group_id = aws_security_group.grpc.id
  from_port = 7100
  to_port = 7100
  protocol = "tcp"

  source_security_group_id = var.sentry_security_group_id
}

// TODO: Lock this down
resource "aws_security_group_rule" "consul_ingress" {
  type = "ingress"
  security_group_id = aws_security_group.grpc.id
  cidr_blocks = ["10.0.0.0/15"]
  from_port = 9100
  to_port = 9100
  protocol = "tcp"
}
