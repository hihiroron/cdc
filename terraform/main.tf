resource "aws_dms_endpoint" "source" {
  database_name               = "postgres"
  endpoint_id                 = "instance-1-new"
  endpoint_type               = "source"
  engine_name                 = "postgres"
  password                    = var.db_password
  port                        = 5432
  server_name = aws_db_instance.postgres.address
  ssl_mode = "require"
  username = "postgres"
}

resource "aws_dms_s3_endpoint" "target" {
  endpoint_id             = "dms-s3-new"
  endpoint_type           = "target"
  bucket_name             = "dms-test-sue"
  service_access_role_arn = aws_iam_role.dms_s3_role.arn
  depends_on = [aws_iam_role_policy.dms_s3_policy]
}

resource "aws_security_group" "dms" {
  name   = "dms-sg"
  vpc_id = "vpc-0790aeb4085749dd4"

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_iam_role" "dms_s3_role" {
  name = "dms-s3-role"

  assume_role_policy = jsonencode({
  Version = "2012-10-17"
  Statement = [
    {
      Effect = "Allow"
        Principal = {
          Service = "dms.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_role_policy" "dms_s3_policy" {
  role = aws_iam_role.dms_s3_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "s3:PutObject",
          "s3:GetObject",
          "s3:ListBucket"
        ]
        Resource = [
          "arn:aws:s3:::dms-test-sue",
          "arn:aws:s3:::dms-test-sue/*"
        ]
      }
    ]
  })
}

resource "aws_dms_replication_config" "postgre-s3-task-new" {
  replication_config_identifier = "postgre-s3-task-new"

  replication_type = "full-load-and-cdc"

  source_endpoint_arn = aws_dms_endpoint.source.endpoint_arn
  target_endpoint_arn = aws_dms_s3_endpoint.target.endpoint_arn

  table_mappings                = <<EOF
  {
    "rules":[{"rule-type":"selection","rule-id":"1","rule-name":"1","rule-action":"include","object-locator":{"schema-name":"%","table-name":"%"}}]
  }
EOF

  compute_config {
    replication_subnet_group_id = aws_dms_replication_subnet_group.main.id
    max_capacity_units           = "1"
    preferred_maintenance_window = "sun:23:45-mon:00:30"
    vpc_security_group_ids = [aws_security_group.dms.id]
  }
}

resource "aws_dms_replication_subnet_group" "main" {
  replication_subnet_group_id          = "dms-subnet-group"
  replication_subnet_group_description = "DMS subnet group"

  subnet_ids = [
    "subnet-0c5161dec38255d09",
    "subnet-0ee2b4800e157dc19",
    "subnet-00885110641b38690"
  ]
}

resource "aws_db_subnet_group" "postgres" {
  name = "postgres-subnet-group"

  subnet_ids = [
    "subnet-0c5161dec38255d09",
    "subnet-0ee2b4800e157dc19",
    "subnet-00885110641b38690"
  ]
}

resource "aws_security_group" "postgres" {
  name        = "postgres-sg"
  description = "PostgreSQL access"
  vpc_id      = "vpc-0790aeb4085749dd4"

  ingress {
  from_port = 5432
  to_port   = 5432
  protocol  = "tcp"
  security_groups = [aws_security_group.dms.id]
}

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_db_parameter_group" "postgres" {
  name   = "postgres-dms"
  family = "postgres18"

  parameter {
    name  = "rds.logical_replication"
    value = "1"
    apply_method = "pending-reboot"
  }
}

resource "aws_db_instance" "postgres" {
  identifier = "database-1-new"

  engine         = "postgres"
  engine_version = "18"

  instance_class = "db.t4g.micro"

  allocated_storage = 20
  storage_type      = "gp3"

  db_name  = "postgres"
  username = "postgres"
  password = var.db_password

  port = 5432

  publicly_accessible = true

  multi_az = false

  db_subnet_group_name   = aws_db_subnet_group.postgres.name
  vpc_security_group_ids = [aws_security_group.postgres.id]

  skip_final_snapshot = true
  deletion_protection = false

  backup_retention_period = 1

  auto_minor_version_upgrade = true
  parameter_group_name = aws_db_parameter_group.postgres.name
}

variable "db_password" {
  type      = string
  sensitive = true
  default = "12345678"
}

