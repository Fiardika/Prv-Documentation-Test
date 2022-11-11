variable "AWS_REGION" {
    default = "ap-southeast-1"
}

#Change the value with your key
variable "AWS_ACCESS_KEY" {
    default = "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"
}

#Change the value with your key
variable "AWS_SECRET_KEY" {
    default = "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxx" 
}

#Change the value with the Private Subnet ID from the VPC creation
variable "subnet_id_1" {
    default = "subnet-xxxxxxxx"
}

#Change the value with the Private Subnet ID from the VPC creation
variable "subnet_id_2" {
    default = "subnet-xxxxxxxx"
}

#Change the value with the Secutiry Group ID from the VPC creation
variable "sg_id" {
    default = "sg-xxxxxxxxx"
}