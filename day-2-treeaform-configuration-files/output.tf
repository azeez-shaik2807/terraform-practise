output "publicIp" {
  value = aws_instance.name.public_ip
}

output "AZ" {
value = aws_instance.name.availability_zone
}

output "pvtIP" {
  value = aws_instance.name.private_ip
}