resource "aws_vpc" "production-vpc" {
 cidr_block           = "192.168.0.0/16"
 enable_dns_support   = true
 enable_dns_hostnames = true

}

data "aws_availability_zones" "available" {
 state = "available"
}


# Create var.az_count private subnets, each in a different AZ
resource "aws_subnet" "production-private-subnet" {
 count             = 2
 cidr_block        = "${cidrsubnet(aws_vpc.production-vpc.cidr_block, 8, count.index)}"
 availability_zone = "${data.aws_availability_zones.available.names[count.index]}"
 vpc_id            =  aws_vpc.production-vpc.id
}

# Create var.az_count public subnets, each in a different AZ
resource "aws_subnet" "production-public-subnet" {
 count                   = 2
 cidr_block              = "${cidrsubnet(aws_vpc.production-vpc.cidr_block, 8, 2 + count.index)}"
 availability_zone       = "${data.aws_availability_zones.available.names[count.index]}"
 vpc_id                  = "${aws_vpc.production-vpc.id}"
 map_public_ip_on_launch = true
}