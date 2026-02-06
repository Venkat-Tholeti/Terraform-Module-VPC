resource "aws_vpc" "main" {
  cidr_block       = var.cidr_block
  instance_tenancy = "default"
  enable_dns_hostnames = "true"

  tags = merge(
    var.vpc_tags, # This is optional check in variables
    local.common_tags,
    {
      Name = "${var.project}-${var.environment}"
    }
  )
}

resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = merge(
    local.common_tags,
    {
      Name = "${var.project}-${var.environment}"
    }
  )
}

resource "aws_subnet" "public" {
  vpc_id     = aws_vpc.main.id
  cidr_block = var.public_subnet_cidr[count.index]
  count = length(var.public_subnet_cidr)
  availability_zone = local.availability_zones_names[count.index]
  map_public_ip_on_launch = true

  tags = merge(
    local.common_tags,
    {
      Name = "${var.project}-${var.environment}-public-${local.availability_zones_names[count.index]}"
    }
  )
}

resource "aws_subnet" "private" {
  vpc_id     = aws_vpc.main.id
  cidr_block = var.private_subnet_cidr[count.index]
  count = length(var.private_subnet_cidr)
  availability_zone = local.availability_zones_names[count.index]
  

  tags = merge(
    local.common_tags,
    {
      Name = "${var.project}-${var.environment}-private-${local.availability_zones_names[count.index]}"
    }
  )
}


resource "aws_subnet" "database" {
  vpc_id     = aws_vpc.main.id
  cidr_block = var.database_subnet_cidr[count.index]
  count = length(var.database_subnet_cidr)
  availability_zone = local.availability_zones_names[count.index]
  

  tags = merge(
    local.common_tags,
    {
      Name = "${var.project}-${var.environment}-database-${local.availability_zones_names[count.index]}"
    }
  )
}