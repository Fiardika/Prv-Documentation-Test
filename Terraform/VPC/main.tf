/*==== VPC for EKS ======*/
resource "aws_vpc" "vpc" {
  cidr_block           = var.VPC_CIDR
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name        = "${var.PROJECT}-vpc"
  }
}

/* Internet gateway for the public subnet */
resource "aws_internet_gateway" "ig" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name        = "${var.PROJECT}-igw"
  }
}

/* Elastic IP for NAT */
resource "aws_eip" "nat_eip" {
  vpc        = true
  depends_on = [aws_internet_gateway.ig]
}

/* NAT */
resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = element(aws_subnet.public_subnet.*.id, 0)
  depends_on    = [aws_internet_gateway.ig]

  tags = {
    Name        = "${var.PROJECT}-nat"
  }
}

/* Public subnet */
resource "aws_subnet" "public_subnet" {
  vpc_id                  = aws_vpc.vpc.id
  count                   = length(var.PUBLIC_SUBNETS_CIDR)
  cidr_block              = element(var.PUBLIC_SUBNETS_CIDR, count.index)
  availability_zone       = element(var.AVAILABILITY_ZONE, count.index)
  map_public_ip_on_launch = true

  tags = {
    Name        = "${var.PROJECT}-${element(var.AVAILABILITY_ZONE, count.index)}-public-subnet"
  }
}

/* Private subnet */
resource "aws_subnet" "private_subnet" {
  vpc_id                  = aws_vpc.vpc.id
  count                   = length(var.PRIVATE_SUBNETS_CIDR)
  cidr_block              = element(var.PRIVATE_SUBNETS_CIDR, count.index)
  availability_zone       = element(var.AVAILABILITY_ZONE, count.index)
  map_public_ip_on_launch = false

  tags = {
    Name        = "${var.PROJECT}-${element(var.AVAILABILITY_ZONE, count.index)}-private-subnet"
  }
}

/* Routing table for private subnet */
resource "aws_route_table" "private" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name        = "${var.PROJECT}-private-route-table"
  }
}

/* Routing table for public subnet */
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name        = "${var.PROJECT}-public-route-table"
  }
}

resource "aws_route" "public_internet_gateway" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.ig.id
}

resource "aws_route" "private_nat_gateway" {
  route_table_id         = aws_route_table.private.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.nat.id
}

/* Route table associations */
resource "aws_route_table_association" "public" {
  count          = length(var.PUBLIC_SUBNETS_CIDR)
  subnet_id      = element(aws_subnet.public_subnet.*.id, count.index)
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "private" {
  count          = length(var.PRIVATE_SUBNETS_CIDR)
  subnet_id      = element(aws_subnet.private_subnet.*.id, count.index)
  route_table_id = aws_route_table.private.id
}

/*==== VPC's Default Security Group ======*/
resource "aws_security_group" "eks_sg" {
  name        = "${var.PROJECT}-eks-sg"
  description = "Default security group to allow inbound/outbound from the VPC"
  vpc_id      = aws_vpc.vpc.id
  depends_on  = [aws_vpc.vpc]

  /* Allow only ssh traffic from internet */
/*  ingress {
    from_port = "22"
    to_port   = "22"
    protocol  = "TCP"
    self      = true
    cidr_blocks      = ["0.0.0.0/0"]
  } */

  ingress {
    from_port = "80"
    to_port   = "80"
    protocol  = "TCP"
    self      = true
    cidr_blocks      = [var.VPC_CIDR]
  }

/*  ingress {
    from_port = "80"
    to_port   = "80"
    protocol  = "TCP"
    self      = true
    cidr_blocks      = [var.VPC_CIDR_INSTANCE]
  } */

  /* 443 Used for Private Access to Kubernetes Controller */

  ingress {
    from_port = "443"
    to_port   = "443"
    protocol  = "TCP"
    self      = true
    cidr_blocks      = [var.VPC_CIDR]
  }

  ingress {
    from_port = "443"
    to_port   = "443"
    protocol  = "TCP"
    self      = true
    cidr_blocks      = [var.VPC_CIDR_INSTANCE]
  }

  /* Allow all outbound traffic to internet */
  egress {
    from_port        = "0"
    to_port          = "0"
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
}

/*==== VPC for Instance ======*/
resource "aws_vpc" "vpc_instance" {
  cidr_block           = var.VPC_CIDR_INSTANCE
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name        = "${var.PROJECT}-vpc-instance"
  }
}

/* Internet gateway for the public subnet */
resource "aws_internet_gateway" "ig_instance" {
  vpc_id = aws_vpc.vpc_instance.id

  tags = {
    Name        = "${var.PROJECT}-igw-instance"
  }
}

/* Public subnet */
resource "aws_subnet" "public_subnet_instance" {
  vpc_id                  = aws_vpc.vpc_instance.id
  count                   = length(var.PUBLIC_SUBNETS_CIDR_INSTANCE)
  cidr_block              = element(var.PUBLIC_SUBNETS_CIDR_INSTANCE, count.index)
  availability_zone       = element(var.AVAILABILITY_ZONE, count.index)
  map_public_ip_on_launch = true

  tags = {
    Name        = "${var.PROJECT}-${element(var.AVAILABILITY_ZONE, count.index)}-public-subnet-instance"
  }
}

/* Routing table for public subnet */
resource "aws_route_table" "public_instance" {
  vpc_id = aws_vpc.vpc_instance.id

  tags = {
    Name        = "${var.PROJECT}-public-instance-route-table"
  }
}

resource "aws_route" "public_instance_internet_gateway" {
  route_table_id         = aws_route_table.public_instance.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.ig_instance.id
}

/* Route table associations */
resource "aws_route_table_association" "public_instance" {
  count          = length(var.PUBLIC_SUBNETS_CIDR_INSTANCE)
  subnet_id      = element(aws_subnet.public_subnet_instance.*.id, count.index)
  route_table_id = aws_route_table.public_instance.id
}

/*==== VPC's Default Security Group ======*/
resource "aws_security_group" "instance_sg" {
  name        = "${var.PROJECT}-instance-sg"
  description = "Default security group to allow inbound/outbound from the VPC"
  vpc_id      = aws_vpc.vpc_instance.id
  depends_on  = [aws_vpc.vpc_instance]

  /* Allow only ssh traffic from internet */
  ingress {
    from_port = "22"
    to_port   = "22"
    protocol  = "TCP"
    self      = true
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  ingress {
    from_port = "80"
    to_port   = "80"
    protocol  = "TCP"
    self      = true
    cidr_blocks      = [var.VPC_CIDR]
    ipv6_cidr_blocks = ["::/0"]
  }

  /* Allow all outbound traffic to internet */
  egress {
    from_port        = "0"
    to_port          = "0"
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
}

  /* VPC Peering */

resource "aws_vpc_peering_connection" "privy_peering" {
  peer_vpc_id   = aws_vpc.vpc.id
  vpc_id        = aws_vpc.vpc_instance.id
  auto_accept   = true

  accepter {
    allow_remote_vpc_dns_resolution = true
  }

  requester {
    allow_remote_vpc_dns_resolution = true
  }

  tags = {
    Name = "VPC Peering between vpc eks and vpc instance"
  }
}

resource "aws_route" "public_route_vpc_instance" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "192.168.0.0/16"
  vpc_peering_connection_id = aws_vpc_peering_connection.privy_peering.id
}

resource "aws_route" "private_route_vpc_instance" {
  route_table_id         = aws_route_table.private.id
  destination_cidr_block = "192.168.0.0/16"
  vpc_peering_connection_id = aws_vpc_peering_connection.privy_peering.id
}

resource "aws_route" "route_vpc_eks" {
  route_table_id         = aws_route_table.public_instance.id
  destination_cidr_block = "10.0.0.0/16"
  vpc_peering_connection_id = aws_vpc_peering_connection.privy_peering.id
}