# ----------------------------
# VPC CREATION
# ----------------------------
resource "aws_vpc" "main" {
  cidr_block = var.cidr_block

  tags = {
    Name = "aziz-vpc"
  }
}

# ----------------------------
# SUBNET 1
# ----------------------------
resource "aws_subnet" "subnet_1" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.subnet_1_cidr
  availability_zone = var.az1

  tags = {
    Name = "subnet-1"
  }
}

# ----------------------------
# SUBNET 2
# ----------------------------
resource "aws_subnet" "subnet_2" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.subnet_2_cidr
  availability_zone = var.az2

  tags = {
    Name = "subnet-2"
  }
}

# ----------------------------
# OUTPUTS (still part of main.tf)
# ----------------------------

output "vpc_id" {
  value = aws_vpc.main.id
}

output "subnet_1_id" {
  value = aws_subnet.subnet_1.id
}

output "subnet_2_id" {
  value = aws_subnet.subnet_2.id
}
