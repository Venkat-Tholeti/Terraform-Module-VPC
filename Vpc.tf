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

resource "aws_subnet" "private" {
  count = length(var.private_subnet_cidr)
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.private_subnet_cidr[count.index]
  availability_zone = local.az_info[count.index]
   #slice(list, start, end) start = 0 → include end = 2 → stop before index 2 (to get 0 & 1 from list)
 

  tags = merge(
        local.common_tags,
        {
            Name = "${var.project}-${var.environment}-private-${local.az_info[count.index]}"
        }
    )
}

resource "aws_subnet" "database" {
  count = length(var.database_subnet_cidr)
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.database_subnet_cidr[count.index]
  availability_zone = local.az_info[count.index]
   #slice(list, start, end) start = 0 → include end = 2 → stop before index 2 (to get 0 & 1 from list)
 

  tags = merge(
        local.common_tags,
        {
            Name = "${var.project}-${var.environment}-database-${local.az_info[count.index]}"
        }
    )
}

#Elastic IP
resource "aws_eip" "nat" {
  domain = "vpc" 
}

resource "aws_nat_gateway" "main" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.public[0].id
  depends_on = [ aws_internet_gateway.main ]
  
  tags = merge(
        local.common_tags,
        {
            Name = "${var.project}-${var.environment}"
        }
    )
}

#ROUTES
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  
  tags = merge(
        local.common_tags,
        {
            Name = "${var.project}-${var.environment}-public"
        }
    )
}

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id

  tags = merge(
        local.common_tags,
        {
            Name = "${var.project}-${var.environment}-private"
        }
    )
}

resource "aws_route_table" "database" {
  vpc_id = aws_vpc.main.id

  tags = merge(
        local.common_tags,
        {
            Name = "${var.project}-${var.environment}-database"
        }
    )
}

resource "aws_route" "public" {
  route_table_id = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id = aws_internet_gateway.main.id
  
  }

resource "aws_route" "private" {
  route_table_id = aws_route_table.private.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id = aws_nat_gateway.main.id

  }

 resource "aws_route" "database" {
  route_table_id = aws_route_table.database.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id = aws_nat_gateway.main.id
  
  }


  resource "aws_route_table_association" "public" {
  count = length(var.public_subnet_cidr)
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}

 resource "aws_route_table_association" "private" {
  count = length(var.private_subnet_cidr)
  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.private.id
}

 resource "aws_route_table_association" "database" {
  count = length(var.database_subnet_cidr)
  subnet_id      = aws_subnet.database[count.index].id
  route_table_id = aws_route_table.database.id
}