variable "AWS_REGION" {
    default = "ap-southeast-1"
}

variable "AWS_ACCESS_KEY" {
    default = "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"
}

variable "AWS_SECRET_KEY" {
    default = "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxx" 
}

variable "PROJECT" {
    default = "Privy"
}

variable "AVAILABILITY_ZONE" {
    default = ["ap-southeast-1a", "ap-southeast-1b"]
}

variable "VPC_CIDR" {
    default = "10.0.0.0/16"
}

variable "VPC_CIDR_INSTANCE" {
    default = "192.168.0.0/16"
}

variable "PUBLIC_SUBNETS_CIDR" {
    default = ["10.0.10.0/24", "10.0.20.0/24"]
}

variable "PUBLIC_SUBNETS_CIDR_INSTANCE" {
    default = ["192.168.1.0/24", "192.168.2.0/24"]
}

variable "PRIVATE_SUBNETS_CIDR" {
    default = ["10.0.30.0/24", "10.0.40.0/24"]
}