variable "vpc" {
  type = "map"
  default = {
    name = "my vpc"
    cidr = "10.10.0.0/16"
  }
}

variable "subnets" {
  type = "list"
  default = [
    {
      name = "my public subnet"
      type = "public"
      cidr = "10.10.1.0/24"
      az = "us-east-1a"
    },
    {
      name = "my private subnet"
      type = "private"
      cidr = "10.10.2.0/24"
    }
  ]
}