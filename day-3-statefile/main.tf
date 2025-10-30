
resource "aws_vpc" "name" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "nakko"
  }

}
resource "aws_subnet" "name" {
vpc_id = aws_vpc.name.id
cidr_block = "10.0.0.0/24"
tags = {
  Name = "hona"
}
}

resource "aws_s3_bucket" "name" {
  bucket = "mera-bucket"
}