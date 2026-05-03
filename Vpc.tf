resource aws_vpc "main" {
    cidr_block = var.cidr_block
    instance_tenancy = "default"
    enable_dns_hostnames = "true"


    tags = merge(
        local.common_tags,
        {
            Name = "${var.project}-${var.environment}"
        }
    )
}

#internet Gateway
resource "aws_internet_gateway" "main" {
    vpc_id = aws_vpc.main.id #association with vpc

     tags = merge(
        local.common_tags,
        {
            Name = "${var.project}-${var.environment}"
        }
    )
}

#Subnets
resource "aws_subnet" "public" {
  count = length(var.public_subnet_cidr)
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.public_subnet_cidr[count.index]
  availability_zone = local.az_info[count.index]
   #slice(list, start, end) start = 0 → include end = 2 → stop before index 2 (to get 0 & 1 from list)
  map_public_ip_on_launch = true # this will launch public ip for instances created in this subnet

  tags = merge(
        local.common_tags,
        {
            Name = "${var.project}-${var.environment}-public-${local.az_info[count.index]}"
        }
    )
}

