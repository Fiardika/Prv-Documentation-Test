output "vpc_id" {
  value = "${aws_vpc.vpc.id}"
}
output "vpc_instance_id" {
  value = "${aws_vpc.vpc_instance.id}"
}

output "public_subnets_id" {
  value = aws_subnet.public_subnet.*.id
}

output "public_subnets_instance_id" {
  value = aws_subnet.public_subnet_instance.*.id
}

output "private_subnets_id" {
  value = aws_subnet.private_subnet.*.id
}

output "eks_sg_id" {
  value = "${aws_security_group.eks_sg.id}"
}

output "instance_sg_id" {
  value = "${aws_security_group.instance_sg.id}"
}