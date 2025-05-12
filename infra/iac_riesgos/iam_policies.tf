# Política para permitir acceso de administración al bucket bronce
resource "aws_iam_policy" "bronze_admin_policy" {
  name        = "bronze-bucket-admin-policy"
  description = "Política para permitir acceso de administración al bucket bronce"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "s3:*"
        ]
        Resource = [
          aws_s3_bucket.bronze_bucket.arn,
          "${aws_s3_bucket.bronze_bucket.arn}/*"
        ]
      }
    ]
  })
}

resource "aws_iam_role" "data_admin_role" {
  name = "data-admin-bronze-role"
  description = "Rol para administradores de datos con acceso completo al bucket bronce"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })

  tags = {
    Project     = "riesgos"
  }
}

resource "aws_iam_role_policy_attachment" "admin_policy_attachment" {
  role       = aws_iam_role.data_admin_role.name
  policy_arn = aws_iam_policy.bronze_admin_policy.arn
}

# Rol IAM para monitoreo de Aurora
resource "aws_iam_role" "rds_monitoring_role" {
  name = "aurora-monitoring-role"
  
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "monitoring.rds.amazonaws.com"
        }
      }
    ]
  })
  
  tags = {
    Project = "riesgos"
    Environment = "dev"
  }
}

resource "aws_iam_role_policy_attachment" "rds_monitoring_policy" {
  role       = aws_iam_role.rds_monitoring_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonRDSEnhancedMonitoringRole"
}

# Política para acceder a Secrets Manager
resource "aws_iam_policy" "secrets_access_policy" {
  name        = "secrets-access-policy"
  description = "Política para acceder a Secrets Manager"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "secretsmanager:GetSecretValue",
          "secretsmanager:DescribeSecret",
          "secretsmanager:ListSecrets"
        ]
        Resource = [
          aws_secretsmanager_secret.aurora_secret.arn,
          "arn:aws:secretsmanager:*:*:secret:aurora-riesgos-*"
        ]
      }
    ]
  })
}

resource "aws_iam_role" "secrets_access_role" {
  name = "secrets-access-role"
  
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = [
            "lambda.amazonaws.com",
            "ec2.amazonaws.com",
            "ecs.amazonaws.com"
          ]
        }
      }
    ]
  })
  
  tags = {
    Project = "riesgos"
  }
}

# Asignar política al rol
resource "aws_iam_role_policy_attachment" "secrets_access_policy_attachment" {
  role       = aws_iam_role.secrets_access_role.name
  policy_arn = aws_iam_policy.secrets_access_policy.arn
} 