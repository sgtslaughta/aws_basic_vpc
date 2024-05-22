variable "project_name" {
  description = "Name of the project"
  type        = string
  default = "test"
}

variable "ec2_kp_pub_cert" {
  description = "EC2 public key certificate"
  type        = string
}

variable "dev_vpc_cidr_block" {
  description = "dev_vpc_cidr_block"
  type        = string
  default     = "10.0.0.0/16"
}

variable "public_subnet_cidr_blocks" {
  description = "Available CIDR blocks for public subnets"
  type        = list(string)
  default = [
    "10.0.1.0/24",
    "10.0.2.0/24",
    "10.0.3.0/24",
    "10.0.4.0/24"
  ]
}

variable "private_subnet_cidr_blocks" {
  description = "Available CIDR blocks for private subnets"
  type        = list(string)
  default = [
    "10.0.101.0/24",
    "10.0.102.0/24",
    "10.0.103.0/24",
    "10.0.104.0/24"
  ]
}


resource "aws_vpc" "dev_vpc" {
  cidr_block           = var.dev_vpc_cidr_block
  enable_dns_hostnames = true

  tags = merge(
    var.additional_tags, {
      Name = "dev_vpc"
    },
  )
}

resource "aws_internet_gateway" "dev_igw" {
  vpc_id = aws_vpc.dev_vpc.id

  tags = merge(
    var.additional_tags, {
      Name = "dev_igw"
    },
  )
}

resource "aws_subnet" "dev_public_subnet" {
  count             = 1
  vpc_id            = aws_vpc.dev_vpc.id
  cidr_block        = var.public_subnet_cidr_blocks[count.index]
  availability_zone = data.aws_availability_zones.available.names[count.index]

  tags = merge(
    var.additional_tags, {
      Name = "dev_public_subnet_${count.index}"
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
      Name = "dev_public_route"
    },
  )
}

resource "aws_route_table_association" "dev_public_route_assoc" {
  count          = 1
  route_table_id = aws_route_table.dev_public_route.id
  subnet_id      = aws_subnet.dev_public_subnet[count.index].id
}

resource "aws_subnet" "dev_private_subnet" {
  count             = 1
  vpc_id            = aws_vpc.dev_vpc.id
  cidr_block        = var.private_subnet_cidr_blocks[count.index]
  availability_zone = data.aws_availability_zones.available.names[count.index]

  tags = merge(
    var.additional_tags, {
      Name = "dev_private_subnet_${count.index}"
    },
  )
}

resource "aws_route_table" "dev_private_route" {
  vpc_id = aws_vpc.dev_vpc.id

  tags = merge(
    var.additional_tags, {
      Name = "dev_private_route"
    },
  )
}

resource "aws_route_table_association" "dev_private_route_assoc" {
  count          = 1
  route_table_id = aws_route_table.dev_private_route.id
  subnet_id      = aws_subnet.dev_private_subnet[count.index].id
}
