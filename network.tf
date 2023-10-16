#vpc 

locals {
    company_name = "${var.company}"
    vpc_name = "vpc-${var.company_name}"
    subnet_pub = "subnet-pub-${var.company_name}"
    subnet_pvt = "subnet-pvt-${var.company_name}"
    igw = "IGW-${var.company_name}"
    route_table_pub = "rt_pub-${var.company_name}"
    route_table_pvt = "rt_pvt-${var.company_name}"
}


resource "aws_vpc" "vpc" {
  cidr_block       = var.vpc_cidr_block
  instance_tenancy = "default"
  enable_dns_hostnames = "true"
 
  tags = {
    Name = local.vpc_name
    company_name = locals.company_name

  }
}

#pub subnets

resource "aws_subnet" "pub_sub1" {
  vpc_id     = aws_vpc.vpc.id
  cidr_block = var.pub-sub_cidr_block[1]
  availability_zone = var.availability_zones[1]
  map_public_ip_on_launch = "true"

  tags = {
    Name = "subpub1"
    subnet_name = local.subnet_pub
}

}
resource "aws_subnet" "pub_sub2" {
  vpc_id     = aws_vpc.vpc.id
  cidr_block = var.pub-sub_cidr_block[2]
  availability_zone = var.availability_zones[2]
  map_public_ip_on_launch = "true"

  tags = {
    Name = "subpub2"
    subnet_name = local.subnet_pub
  }
}

#IGW

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = locals.igw
  }
}

#public_route_table1
resource "aws_route_table" "pub_rt1" {
  vpc_id = aws_vpc.VPC.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
   tags = {
    Name = "Rt-Pub1"
    route_name = locals.route_table_pub
  }
}

#Public_route_table association1

resource "aws_route_table_association" "pub_rt_ass1" {
  subnet_id      = aws_subnet.pub_sub1.id
  route_table_id = aws_route_table.pub_rt1.id
}

#public_route_table2

resource "aws_route_table" "pub_rt_2" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
   tags = {
    Name = "Rt-Pub1"
    route_name = local.route_table_pub
}

}
#public_route_table association2

resource "aws_route_table_association" "pub_rt_ass2" {
  subnet_id      = aws_subnet.pub_sub2.id
  route_table_id = aws_route_table.pub_rt2.id
}


#pvt subnets1

resource "aws_subnet" "pvt_sub1" {
  vpc_id     = aws_vpc.vpc.id
  cidr_block = var.pub-sub1_cidr_block
  availability_zone = var.availability_zones[3]
  map_public_ip_on_launch = "false"
   tags = {
    Name = "subpvt1"
    subnet_name = local.subnet_pvt
  }
}

#pvt route_table1

resource "aws_route_table" "pvt_rt1" {
  vpc_id = aws_vpc.VPC.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.nat.id
  }
  tags = {
    Name = "Rt-Pub1"
    route_name = local.route_table_pub
  }
}
#Pvt_route_table association1

resource "aws_route_table_association" "pvt_rt_ass1" {
  subnet_id      = aws_subnet.pvt_sub1.id
  route_table_id = aws_route_table.pvt_rt1.id
}

#security group

resource "aws_security_group" "sg" {
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
    Name = locals.project-name
  }
}

#Eip 
resource "aws_eip" "eip"{
  vpc = true
}

#NAT Gatway public

resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.eip.id
  subnet_id     = aws_subnet.pvt_sub1.id

  tags = {
    Name = locals.company_name
  }
}
