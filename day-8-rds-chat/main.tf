# ------------------------
# VPC (optional if you already have one)
# ------------------------
resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "rds-vpc"
  }
}

# ------------------------
# Subnets for RDS
# ------------------------
resource "aws_subnet" "subnet1" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "us-east-1a"
  map_public_ip_on_launch = true
  tags = {
    Name = "subnet-1"
  }
}

resource "aws_subnet" "subnet2" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.2.0/24"
  availability_zone       = "us-east-1b"
  map_public_ip_on_launch = true
  tags = {
    Name = "subnet-2"
  }
}

# ------------------------
# Security Group for RDS
# ------------------------
resource "aws_security_group" "rds_sg" {
  name        = "rds-security-group"
  description = "Allow MySQL traffic"
  vpc_id      = aws_vpc.main.id

  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # Allow public access (Not secure for production)
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "rds-sg"
  }
}

# ------------------------
# Subnet Group for RDS
# ------------------------
resource "aws_db_subnet_group" "rds_subnet_group" {
  name       = "rds-subnet-group"
  subnet_ids = [aws_subnet.subnet1.id, aws_subnet.subnet2.id]
  tags = {
    Name = "rds-subnet-group"
  }
}

# ------------------------
# RDS Instance
# ------------------------
resource "aws_db_instance" "my_rds" {
  allocated_storage      = 20
  engine                 = "mysql"
  engine_version         = "8.0"
  instance_class         = "db.t3.micro"
  db_name                = "mydb"
  username               = "admin"
  password               = "Admin1234!"
  parameter_group_name   = "default.mysql8.0"
  skip_final_snapshot    = true
  publicly_accessible    = false
  backup_retention_period = 7
  vpc_security_group_ids = [aws_security_group.rds_sg.id]
  db_subnet_group_name   = aws_db_subnet_group.rds_subnet_group.name

  tags = {
    Name = "terraform-rds"
  }
}

# ------------------------
# Output
# ------------------------
output "rds_endpoint" {
  value = aws_db_instance.my_rds.endpoint
}


# ------------------------
# RDS Read Replica
# ------------------------
resource "aws_db_instance" "my_rds_replica" {
  replicate_source_db = aws_db_instance.my_rds.arn
  instance_class         = "db.t3.micro"
  publicly_accessible    = false
  skip_final_snapshot    = true
  apply_immediately      = true

  vpc_security_group_ids = [aws_security_group.rds_sg.id]
  db_subnet_group_name   = aws_db_subnet_group.rds_subnet_group.name

  depends_on = [aws_db_instance.my_rds]

  tags = {
    Name = "terraform-rds-replica"
  }
}
