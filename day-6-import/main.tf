resource "aws_instance" "name" {
  instance_type = "t2.micro"
  ami = "ami-0bdd88bd06d16ba03"
  tags = {
    Name = "import-test"
  }
}