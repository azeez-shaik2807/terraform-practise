# variable "aws_region" {
#   description = "The region in which to create the infrastructure"
#   type        = string
#   nullable    = false
#   default     = "us-east-1" #here we need to define either us-west-1 or eu-west-2 if i give other region will get error 
#   validation {
#     condition = var.aws_region == "us-east-1" || var.aws_region == "eu-west-1"
#     error_message = "The variable 'aws_region' must be one of the following regions: us-east-1, eu-west-1"
#   }
# }

# provider "aws" {
#   region = "us-west-2"
  
   
#  }

#  resource "aws_s3_bucket" "dev" {
#     bucket = "meri-bucket-rs-100"
    
  
# }

#after run this will get error like The variable 'aws_region' must be one of the following regions: us-west-2,│ eu-west-1, so it will allow any one region defined above in conditin block



### Example-2
variable "create_bucket" {
  type    = bool
  default = true
}

resource "aws_s3_bucket" "example" {
  count  = var.create_bucket ? 1 : 0
  bucket = "meri-bucket-rs-1000"
}

## Example-3
# variable "environment" {
#   type    = bool
#   default = true
# }

# resource "aws_instance" "aziz" {
#   count         = var.environment == "prod" ? 3 : 1
#   ami           = "ami-0cae6d6fe6048ca2c"
#   instance_type = "t2.micro"

#   tags = {
#     Name = "aziz-${count.index}"
#   }
# }

# #In this case:
# #If var.environment == "prod" → count = 3
# #Else (like dev, qa, etc.) → count = 1
# #terraform apply -var="environment=dev"