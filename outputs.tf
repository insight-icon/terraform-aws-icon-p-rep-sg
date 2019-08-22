output "security_group_ids" {
  value = [aws_security_group.rest.id, aws_security_group.grpc.id]
}

