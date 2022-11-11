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

variable "INSTANCE_TYPE" {
  default   =  "t2.micro"
}

variable "PROJECT" {
    default = "Privy"
}

#This AMI is AWS template for Ubuntu
variable "AMI" {
  default   =  "ami-00e912d13fbb4f225"
}

variable "KEY" {
  default   =  "dell"
}

#Change the value with the Subnet ID from the VPC creation
variable "SUBNET_ID" {
  default   =  "subnet-xxxxxxxxxxxx"
}

#Change the value with the Secutiry Group ID from the VPC creation
variable "SECURITY_GROUP" {
  default   =  ["sg-xxxxxxxxxx"]
}