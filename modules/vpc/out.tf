output "vpc-id" {
  value = "${aws_vpc.vpc.id}"
}

output "vpc-arn" {
  value = "${aws_vpc.vpc.arn}"
}


output "subnet-ids" {
  value = "${aws_subnet.subnets.*.id}"
}

output "subnets-arn" {
  value = "${aws_subnet.subnets.*.arn}"
}

output "public-subnet-ids" {
  value = "${local.public-ids}"
}

output "private-subnet-ids" {
  value = "${local.public-ids}"
}