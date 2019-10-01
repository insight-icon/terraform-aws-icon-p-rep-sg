output "security_group_ids" {
  value = [aws_security_group.rest.id, aws_security_group.grpc.id]
}

output "rest_security_group_id" {
  value = aws_security_group.rest.id
}

output "grpc_security_group_id" {
  value = aws_security_group.grpc.id
}
