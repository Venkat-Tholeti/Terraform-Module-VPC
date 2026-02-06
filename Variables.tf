variable "project" {
    type = string
}

variable "environment" {
    type = string
}

variable "cidr_block" {
   default = "10.0.0.0/16"
}

variable  "public_subnet_cidr" {
  type = list(string)
}

variable  "private_subnet_cidr" {
  type = list(string)
}

variable  "database_subnet_cidr" {
  type = list(string)
}

#If we need a variable to be optional we have to keep default ={} , then that block will be optional to users.If they want they can use or else they can leave that block.example follows

variable  "vpc_tags" {
  type = map(string)
  default = {}
}

variable  "igw_tags" {
  type = map(string)
  default = {}
}