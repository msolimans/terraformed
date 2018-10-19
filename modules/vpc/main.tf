
data "null_data_source" "subnets" {
  count = "${length(var.subnets)}"
  inputs = {
    type = "${ lookup(var.subnets[count.index], "type", "")}"
    cidr = "${ lookup(var.subnets[count.index], "cidr", "")}"
  }
}

locals {

  public-ids = "${matchkeys(aws_subnet.subnets.*.id, data.null_data_source.subnets.*.outputs.type, list("public"))}"
  private-ids = "${matchkeys(aws_subnet.subnets.*.id, data.null_data_source.subnets.*.outputs.type, list("private"))}"
}


resource "aws_vpc" "vpc" {
  instance_tenancy = "default"
  enable_dns_support = "true"
  enable_dns_hostnames = "true"
  cidr_block = "${lookup(var.vpc, "cidr")}"
  tags {
    Name = "${lookup(var.vpc,"name")}"
  }
}



data "null_data_source" "public-subnets-len" {

  inputs {
    value = "${length(matchkeys(data.null_data_source.subnets.*.outputs, data.null_data_source.subnets.*.outputs.type, list("public")))}"
  }
}


locals {
  azs = [
    "us-east-1a",
    "us-east-1b",
    "us-east-1c",
    "us-east-1d"
  ]
}


resource "aws_subnet" "subnets" {
  count = "${length(var.subnets)}"

  cidr_block = "${lookup(var.subnets[count.index], "cidr")}"
  vpc_id = "${aws_vpc.vpc.id}"
  map_public_ip_on_launch = "${lookup(var.subnets[count.index], "type") == "public"? "true": "false"}"
  //  availability_zone = "${lookup(element(var.subnets, count.index), "az") == ""? element(local.azs, count.index % length(var.subnets)) :${lookup(element(var.subnets, count.index), "cidr")} }"

  tags {
    Name = "${lookup(var.subnets[count.index], "name")}"
  }
}





#add igw in case if there is at least one public
resource "aws_internet_gateway" "igw" {
  count = "${data.null_data_source.public-subnets-len.*.outputs.value[0]  > 0 ? 1 : 0}"
  tags {
    name = "igw for vpc named ${var.vpc["name"]}"
  }
  vpc_id = "${aws_vpc.vpc.id}"
}


#create a new route table in case at least one public
resource "aws_route_table" "public-rtb" {
  vpc_id = "${aws_vpc.vpc.id}"
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.igw.id}"
  }
  count = "${data.null_data_source.public-subnets-len.*.outputs.value[0]  > 0? 1 : 0}"
}


#create subnet association in case there is at least one public
resource "aws_route_table_association" "public-rtb-assoc" {
  route_table_id = "${aws_route_table.public-rtb.id}"
  count = "${data.null_data_source.public-subnets-len.*.outputs.value[0]}"
  subnet_id = "${local.public-ids[count.index]}"
}

