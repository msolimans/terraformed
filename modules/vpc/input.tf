variable "vpc" {
  type = "map"
  default = {
    name = "vpc"
    cidr = "10.10.0.0/16"
  }
}

variable "subnets" {
  type = "list"
  default = [
    {
      name = "public"
      type = "public"
      cidr = "10.10.1.0/24"
      az = "us-east-1a"
    },
    {
      name = "private"
      type = "private"
      cidr = "10.10.2.0/24"
    }
  ]
}