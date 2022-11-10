variable "AWS_REGION" {
    default = "ap-southeast-1"
}

variable "AWS_ACCESS_KEY" {
    default = "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"
}

variable "AWS_SECRET_KEY" {
    default = "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxx" 
}

variable "INSTANCE_TYPE" {
  default   =  "t2.micro"
}

variable "PROJECT" {
    default = "Privy"
}

variable "AMI" {
  default   =  "ami-00e912d13fbb4f225"
}

variable "KEY" {
  default   =  "dell"
}

variable "SUBNET_ID1" {
  default   =  "subnet-04b4a047344fb24aa"
}

variable "SUBNET_ID2" {
  default   =  "subnet-045e2ea26f640f805"
}

variable "SECURITY_GROUP" {
  default   =  ["sg-0c148bff3fdab6d3f"]
}