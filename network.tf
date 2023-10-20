#vpc 

locals {
  company_name    = var.company_name
  vpc_name        = "${var.company_name}-vpc"
  subnet_pub      = "${var.company_name}-subnet-pub"
  subnet_pvt      = "${var.company_name}-subnet-pvt"
  igw             = "${var.company_name}-IGW"
  route_table_pub = "${var.company_name}-rt_pub"
  route_table_pvt = "${var.company_name}-rt_pvt"
}


resource "aws_vpc" "vpc" {
  cidr_block           = var.vpc_cidr_block
  instance_tenancy     = "default"
  enable_dns_hostnames = "true"

  tags = {
    Name         = local.vpc_name
    company_name = local.company_name

  }
}

#pub subnets

resource "aws_subnet" "pub_sub1" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = var.pub_sub_cidr_block[0]
  availability_zone       = var.availability_zones[0]
  map_public_ip_on_launch = "true"

  tags = {
    Name        = "${local.subnet_pub}-1"
  }

}
resource "aws_subnet" "pub_sub2" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = var.pub_sub_cidr_block[1]
  availability_zone       = var.availability_zones[1]
  map_public_ip_on_launch = "true"

  tags = {
    Name        = "${local.subnet_pub}-2"   
  }
}

#IGW

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = local.igw
  }
}

#public_route_table1
resource "aws_route_table" "pub_rt1" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
  tags = {
    Name       = "${local.route_table_pub}-1"
  }
}

#Public_route_table association1

resource "aws_route_table_association" "pub_rt_ass1" {
  subnet_id      = aws_subnet.pub_sub1.id
  route_table_id = aws_route_table.pub_rt1.id
}

#public_route_table2

resource "aws_route_table" "pub_rt2" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
  tags = {
    Name       = "${local.route_table_pub}-2"
  }

}
#public_route_table association2

resource "aws_route_table_association" "pub_rt_ass2" {
  subnet_id      = aws_subnet.pub_sub2.id
  route_table_id = aws_route_table.pub_rt2.id
}


#pvt subnets1

resource "aws_subnet" "pvt_sub1" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = var.pvt_sub1_cidr_block
  availability_zone       = var.availability_zones[2]
  map_public_ip_on_launch = "false"
  tags = {
    Name        = "${local.subnet_pvt}-1"
  }
}

#pvt route_table1

resource "aws_route_table" "pvt_rt1" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.nat.id
  }
  tags = {
    Name       = "${local.route_table_pvt}-1"
  }
}
#Pvt_route_table association1

resource "aws_route_table_association" "pvt_rt_ass1" {
  subnet_id      = aws_subnet.pvt_sub1.id
  route_table_id = aws_route_table.pvt_rt1.id
}

#security group

resource "aws_security_group" "sg-pub" {
  name        = "Security Group"
  description = "Allow TLS inbound traffic"
  vpc_id      = aws_vpc.vpc.id

  ingress {
    description      = "HTTPS"
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  ingress {
    description      = "HTTP"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }


  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "${local.company_name}-SG-PUB"
  }
}

#Security Group Pvt

resource "aws_security_group" "sg-pvt" {
  name        = "Security Group"
  description = "Allow TLS inbound traffic"
  vpc_id      = aws_vpc.vpc.id

  ingress {
    description      = "HTTPS"
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
    security_groups = [aws_security_group.sg-pub.id]
  }

  ingress {
    description      = "SSH"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    security_groups = [aws_security_group.sg-pub.id]
  }
  ingress {
    description      = "HTTP"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    security_groups = [aws_security_group.sg-pub.id]
  }


  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "${local.company_name}-SG-PVT"
  }
}

#Eip 
resource "aws_eip" "eip" {
  vpc = true
}

#NAT Gatway public

resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.eip.id
  subnet_id     = aws_subnet.pvt_sub1.id

  tags = {
    Name = "${local.company_name}-NATG"
  }
}
