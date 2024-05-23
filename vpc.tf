
data "aws_availability_zones" "available" {
  state = "available"
}

## Create a VPC
resource "aws_vpc" "dev_vpc" {
  cidr_block           = var.dev_vpc_cidr_block
  enable_dns_hostnames = true

  tags = merge(
    var.additional_tags, {
      Name = "${var.project_shortname}_vpc"
    },
  )
}

resource "aws_internet_gateway" "dev_igw" {
  vpc_id = aws_vpc.dev_vpc.id

  tags = merge(
    var.additional_tags, {
      Name = "${var.project_shortname}_igw"
    },
  )
}

#### Create a public subnet
resource "aws_subnet" "dev_public_subnet" {
  count             = 1
  vpc_id            = aws_vpc.dev_vpc.id
  cidr_block        = var.public_subnet_cidr_blocks[count.index]
  availability_zone = data.aws_availability_zones.available.names[count.index]

  tags = merge(
    var.additional_tags, {
      Name = "${var.project_shortname}_pub_subnet_${count.index}"
    },
  )
}

resource "aws_route_table" "dev_public_route" {
  vpc_id = aws_vpc.dev_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.dev_igw.id
  }

  tags = merge(
    var.additional_tags, {
      Name = "${var.project_shortname}_public_route"
    },
  )
}

resource "aws_route_table_association" "dev_public_route_assoc" {
  count          = 1
  route_table_id = aws_route_table.dev_public_route.id
  subnet_id      = aws_subnet.dev_public_subnet[count.index].id
}
#######################  End  ###############################

#######################  Private subnet #####################
resource "aws_subnet" "dev_private_subnet" {
  count             = 1
  vpc_id            = aws_vpc.dev_vpc.id
  cidr_block        = var.private_subnet_cidr_blocks[count.index]
  availability_zone = data.aws_availability_zones.available.names[count.index]

  tags = merge(
    var.additional_tags, {
      Name = "${var.project_shortname}_priv_subnet_${count.index}"
    },
  )
}

resource "aws_route_table" "dev_private_route" {
  vpc_id = aws_vpc.dev_vpc.id

  tags = merge(
    var.additional_tags, {
      Name = "${var.project_shortname}_priv_route"
    },
  )
}

resource "aws_route_table_association" "dev_private_route_assoc" {
  count          = 1
  route_table_id = aws_route_table.dev_private_route.id
  subnet_id      = aws_subnet.dev_private_subnet[count.index].id
}
#######################  End  ###############################