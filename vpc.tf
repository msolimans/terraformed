module "myvpc" {
  source = "modules/vpc"
  vpc = {
    name = "my vpc"
    cidr = "10.10.0.0/16"
  }

  "subnets" = [
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


output "vpc-arn" {
  value = "${module.myvpc.vpc-arn}"
}

output "myvpc-id" {
  value = "${module.myvpc.vpc-id}"
}

output "subnet-ids" {
  value = "${join(",", module.myvpc.subnet-ids)}"
}
output "public-subnet-ids" {
  value = "${join(",", module.myvpc.public-subnet-ids)}"
}

output "private-subnet-ids" {
  value = "${join(",", module.myvpc.private-subnet-ids)}"
}

