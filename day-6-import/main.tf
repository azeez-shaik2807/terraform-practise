resource "aws_instance" "name" {
  instance_type = "t2.micro"
  ami = "ami-0bdd88bd06d16ba03"
  tags = {
    Name = "import-test"
  }
}



# terraform import respurce.name id/name
# terraform import aws_instance.name i-0cd1d77ae558c4257
# terraform import aws_s3_bucket.name bucket-name