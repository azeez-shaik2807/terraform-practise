# resource "aws_instance" "name" {
#     ami = "ami-0cae6d6fe6048ca2c"
#     instance_type = "t2.micro"
#     count = 2
#     # tags = {
#     #   Name = "aziz"
#     # }
#   tags = {
#       Name = "aziz-${count.index}"
#     }
# }

variable "env" {
    type = list(string)
    default = [ "aziz", "numan"]
  
}

resource "aws_instance" "name" {
    ami = "ami-0cae6d6fe6048ca2c"
    instance_type = "t2.micro"
    count = length(var.env)
    # tags = {
    #   Name = "dev"
    # }
  tags = {
      Name = var.env[count.index]
    }
}