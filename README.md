## Estructura del Proyecto

- `docs/`: Diagramas y documentación general
  - `arquitectura_integral.drawio`: Diagrama completo de la arquitectura del sistema
- `architecture/`: Modelamiento y exposición de datos
  - `data_model/`: Modelos de datos
    - `medallion_database/`: Arquitectura de datos tipo medallón
      - `bronze_layer/`: Capa de datos crudos
      - `silver_layer/`: Capa de datos refinados
      - `gold_layer/`: Capa de datos de consumo
- `infra/`: Código IaC

# Infraestructura de Datos - Proyecto Riesgos

Este proyecto implementa una arquitectura de datos moderna utilizando:
- Arquitectura medallón para el procesamiento de datos
- Lago de datos en AWS S3
- Base de datos Aurora PostgreSQL Serverless
- Servicios de AWS para procesamiento y análisis

## Arquitectura de Datos

### Capa Bronze
- Almacenamiento de datos crudos en S3
- Replicación de datos desde fuentes externas
- Sin transformaciones significativas
- Mantiene la estructura original de los datos

### Capa Silver
- Datos refinados y validados
- Transformaciones básicas y limpieza
- Estructura optimizada para consultas
- Almacenamiento en Aurora PostgreSQL

### Capa Gold
- Datos de consumo final
- Vistas materializadas y agregaciones
- Optimizada para análisis y reporting
- Integración con herramientas de BI

## Componentes de la Arquitectura

### Procesamiento de Datos
- AWS Glue para ETL
- AWS Lambda para procesamiento serverless
- AWS Step Functions para orquestación

### Almacenamiento
- S3 para datos crudos (Bronze)
- Aurora PostgreSQL para datos procesados (Silver/Gold)
- OpenSearch para búsqueda vectorial

### Seguridad y Gobernanza
- AWS Lake Formation para control de acceso
- AWS Secrets Manager para credenciales
- IAM para gestión de permisos

Este proyecto contiene la infraestructura como código (IaC) para el proyecto de Riesgos, implementando un lago de datos con arquitectura medallón y una base de datos Aurora PostgreSQL Serverless.

```
infra/
└── iac_riesgos/
    ├── s3_bucket_bronze.tf        # Configuración del bucket S3 para la capa bronce
    ├── rds_riesgos_serveless.tf   # Configuración de Aurora PostgreSQL Serverless
    ├── secrets_manager.tf         # Gestión de secretos para credenciales
    ├── security.tf                # Configuración de red y seguridad
    └── outputs.tf                 # Outputs de la infraestructura
```

## Prerrequisitos

1. AWS CLI instalado y configurado
   ```bash
   aws --version
   ```

2. Terraform v1.0.0 o superior
   ```bash
   terraform --version
   ```

3. Acceso a una cuenta AWS con los permisos necesarios
   - IAMFullAccess
   - AmazonS3FullAccess
   - AmazonRDSFullAccess
   - SecretsManagerFullAccess
   - AmazonVPCFullAccess

4. Credenciales AWS configuradas
   ```bash
   aws configure
   ```

## Configuración Inicial

1. Clonar el repositorio:
   ```bash
   git clone <url-del-repositorio>
   cd <nombre-del-repositorio>
   ```

2. Navegar al directorio de la infraestructura:
   ```bash
   cd infra/iac_riesgos
   ```

## Despliegue de la Infraestructura

1. Inicializar Terraform:
   ```bash
   terraform init
   ```
   Este comando descargará los providers necesarios y configurará el backend.

2. Revisar el plan de ejecución:
   ```bash
   terraform plan
   ```
   Verifica los recursos que se crearán:
   - VPC y subnets
   - Security groups
   - Bucket S3
   - Aurora PostgreSQL Serverless
   - Secrets Manager

3. Aplicar la infraestructura:
   ```bash
   terraform apply
   ```
   Confirma la creación de recursos escribiendo 'yes' cuando se solicite.

4. Verificar los outputs:
   ```bash
   terraform output
   ```
   Esto mostrará información importante como:
   - Endpoint de Aurora
   - Nombre del bucket S3
   - ARN del secret en Secrets Manager

## Componentes Desplegados

### Red (security.tf)
- VPC con CIDR 10.0.0.0/16
- 2 subnets públicas en diferentes AZs
- Internet Gateway
- Route tables
- Security group para Aurora

### Capa Bronce (s3_bucket_bronze.tf)
- Bucket S3: zona-bronce-datos-riesgos
- Bloqueo de acceso público
- Configuración de seguridad

### Base de Datos (rds_riesgos_serveless.tf)
- Cluster Aurora PostgreSQL Serverless v2
- Escalado automático (0.5 - 2 ACU)
- Encriptación habilitada
- Backup diario

### Gestión de Secretos (secrets_manager.tf)
- Secret para credenciales de Aurora
- Rotación automática
- Contraseña generada aleatoriamente

## Acceso a los Recursos

### Base de Datos Aurora
1. Obtener las credenciales:
   ```bash
   aws secretsmanager get-secret-value --secret-id aurora-riesgos-credenciales
   ```

2. Conectar a la base de datos:
   ```bash
   psql -h <endpoint> -U admin -d db_riesgos
   ```

### Bucket S3
1. Listar objetos:
   ```bash
   aws s3 ls s3://zona-bronce-datos-riesgos
   ```

2. Subir archivos:
   ```bash
   aws s3 cp <archivo-local> s3://zona-bronce-datos-riesgos/<ruta-destino>
   ```

## Monitoreo y Mantenimiento

1. Ver logs de Aurora:
   ```bash
   aws rds describe-db-log-files --db-cluster-identifier aurora-riesgos
   ```

2. Monitorear costos:
   ```bash
   aws ce get-cost-and-usage --time-period Start=2024-01-01,End=2024-12-31 --granularity MONTHLY
   ```

## Destrucción de la Infraestructura

1. Revisar recursos a eliminar:
   ```bash
   terraform plan -destroy
   ```
   Verifica que todos los recursos listados son los que deseas eliminar.

2. Destruir la infraestructura:
   ```bash
   terraform destroy
   ```
   Confirma la destrucción escribiendo 'yes' cuando se solicite.

   **Nota**: Este proceso eliminará:
   - El cluster Aurora y sus instancias
   - El bucket S3 y su contenido
   - Los secrets en Secrets Manager
   - La VPC y todos los recursos de red
   - Los security groups

## Consideraciones Importantes

1. **Costos**:
   - Aurora Serverless se factura por uso (ACU)
   - Monitorear el uso en AWS Cost Explorer
   - Configurar alertas de presupuesto

2. **Seguridad**:
   - Las credenciales rotan automáticamente
   - Acceso restringido mediante security groups
   - Encriptación habilitada en todos los recursos

3. **Backups**:
   - Aurora mantiene backups por 1 día
   - Los datos en S3 deben ser respaldados manualmente