# ---------------------------
# VPC and Subnets
# ---------------------------

resource "aws_vpc" "name" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "terraform-vpc"
  }
}

resource "aws_subnet" "net-1" {
  vpc_id            = aws_vpc.name.id
  cidr_block        = "10.0.0.0/24"
  availability_zone = "us-east-1a"
}

resource "aws_subnet" "net-2" {
  vpc_id            = aws_vpc.name.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "us-east-1b"
}

# ---------------------------
# DB Subnet Group
# ---------------------------

resource "aws_db_subnet_group" "sub-grp" {
  name       = "mysubnet1"
  subnet_ids = [aws_subnet.net-1.id, aws_subnet.net-2.id]

  tags = {
    Name = "My DB subnet group"
  }
}

# ---------------------------
# IAM Role for Enhanced Monitoring
# ---------------------------

resource "aws_iam_role" "rds_monitoring" {
  name = "rds-monitoring-role-prashanth"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "monitoring.rds.amazonaws.com"
      }
    }]
  })
}

resource "aws_iam_role_policy_attachment" "rds_monitoring_attach" {
  role       = aws_iam_role.rds_monitoring.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonRDSEnhancedMonitoringRole"
}

# ---------------------------
# Primary RDS Instance
# ---------------------------

resource "aws_db_instance" "default" {
  allocated_storage       = 10
  db_name                 = "mydb"
  identifier              = "terraform-rds"
  engine                  = "mysql"
  engine_version          = "8.0"
  instance_class          = "db.t3.micro"
  username                = "admin"
  password                = "azeez2807"
  db_subnet_group_name    = aws_db_subnet_group.sub-grp.name
  parameter_group_name    = "default.mysql8.0"

  # Backups
  backup_retention_period = 7
  backup_window           = "02:00-03:00"

  # Monitoring
  monitoring_interval     = 60
  monitoring_role_arn     = aws_iam_role.rds_monitoring.arn

  # Maintenance
  maintenance_window      = "sun:04:00-sun:05:00"

  # Protection & Snapshot
  deletion_protection     = false
  skip_final_snapshot     = true

  tags = {
    Name = "RDS-Primary"
  }
}

# ---------------------------
# Read Replica
# ---------------------------

resource "aws_db_instance" "replica" {
  identifier                 = "rds-read-replica"
  replicate_source_db        =  "arn:aws:rds:us-east-1:022687720917:db:rds-rds"
  instance_class             = "db.t3.micro"
  publicly_accessible        = false
  db_subnet_group_name       = aws_db_subnet_group.sub-grp.name
  parameter_group_name       = "default.mysql8.0"
  monitoring_interval        = 60
  monitoring_role_arn        = aws_iam_role.rds_monitoring.arn
  skip_final_snapshot        = true
  deletion_protection        = false

 tags = {
    Name = "RDS-Read-Replica"
  }
}



#first you create a database and commend this read replica while terraform apply -auto-approve
#then after creating a database take the arn of the database and change the replicate_source_db ="arn of database" 
#if we want add sg for db also we can add here