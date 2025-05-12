# Configuración de Aurora PostgreSQL Serverless v2
resource "aws_db_subnet_group" "aurora_subnets" {
  name       = "aurora-subnet-group"
  subnet_ids = [aws_subnet.subnet_a.id, aws_subnet.subnet_b.id]
  
  tags = {
    Project = "riesgos"
  }
}

resource "aws_rds_cluster" "aurora_cluster" {
  cluster_identifier      = "aurora-riesgos"
  engine                  = "aurora-postgresql"
  engine_mode             = "provisioned"
  engine_version          = "15.3"
  master_username         = "riesgos"
  master_password         = random_password.aurora_password.result
  db_subnet_group_name    = aws_db_subnet_group.aurora_subnets.name
  vpc_security_group_ids  = [aws_security_group.rds_sg.id]
  skip_final_snapshot     = true
  backup_retention_period = 1
  storage_encrypted       = true

  serverlessv2_scaling_configuration {
    min_capacity = 0.5
    max_capacity = 2
  }

  tags = {
    Project = "riesgos"
  }
}

resource "aws_rds_cluster_instance" "aurora_instance" {
  identifier              = "aurora-riesgos-instancia"
  cluster_identifier      = aws_rds_cluster.aurora_cluster.id
  instance_class          = "db.serverless"
  engine                  = aws_rds_cluster.aurora_cluster.engine
  engine_version          = aws_rds_cluster.aurora_cluster.engine_version
  publicly_accessible     = false

  tags = {
    Project = "riesgos"
  }
} 