output "bucket_s3_bronze" {
  description = "Nombre del bucket S3 para zona Bronze"
  value       = aws_s3_bucket.bronze_bucket.bucket
}

output "aurora_endpoint" {
  description = "Endpoint del cluster Aurora PostgreSQL"
  value       = aws_rds_cluster.aurora_cluster.endpoint
}

output "secrets_manager_arn" {
  description = "ARN del secreto de credenciales RDS"
  value       = aws_secretsmanager_secret.aurora_secret.arn
}

output "vpc_id" {
  description = "ID de la VPC creada"
  value       = aws_vpc.vpc_datos.id
}

output "subnet_ids" {
  description = "IDs de las subnets públicas"
  value       = [aws_subnet.subnet_a.id, aws_subnet.subnet_b.id]
}

output "security_group_id" {
  description = "ID del Security Group asignado a la RDS"
  value       = aws_security_group.rds_sg.id
}