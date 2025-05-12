# Secret para credenciales de Aurora
resource "aws_secretsmanager_secret" "aurora_secret" {
  name = "aurora-riesgos-credenciales"
  description = "Credenciales para la base de datos Aurora PostgreSQL"
  
  tags = {
    Project = "riesgos"
  }
}

resource "random_password" "aurora_password" {
  length           = 16
  special          = true
  override_special = "!#$%&*()-_=+[]{}<>:?"
}

resource "aws_secretsmanager_secret_version" "aurora_secret_version" {
  secret_id     = aws_secretsmanager_secret.aurora_secret.id
  secret_string = jsonencode({
    username = "riesgos"
    password = random_password.aurora_password.result
    engine   = "aurora-postgresql"
    port     = 5432
    dbname   = "bd_financiera"
  })
}

# Actualizar secret con host real una vez creado el cluster
resource "aws_secretsmanager_secret_version" "aurora_secret_update" {
  secret_id     = aws_secretsmanager_secret.aurora_secret.id
  secret_string = jsonencode({
    username = "riesgos"
    password = random_password.aurora_password.result
    engine   = "aurora-postgresql"
    host     = aws_rds_cluster.aurora_cluster.endpoint
    port     = 5432
    dbname   = "db_riesgos"
  })
  
  depends_on = [aws_rds_cluster.aurora_cluster]
}