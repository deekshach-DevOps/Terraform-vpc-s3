# How to create AWS - vpc, subnet, internet gateway, Routetable, security groups, EC2-Instance, S3 bucket using Terraform 

terraform {
  backend "s3" {
    bucket = "myterraforms3bucketcloud"
    key    = "state/terraform.tfstate"
    region = "eu-north-1"
  }
}


resource "aws_vpc" "demo-vpc" {
  cidr_block = "10.0.0.0/21"

  tags = {
    Name = "demo-vpc"
  }
}


resource "aws_subnet" "demo-subnet" {
  vpc_id                  = aws_vpc.demo-vpc.id
  cidr_block              = "10.0.0.0/24"
  availability_zone       = "eu-north-1a"
  map_public_ip_on_launch = true

  tags = {
    Name = "demo-subnet"
  }
}

resource "aws_internet_gateway" "demo-igw" {
  vpc_id = aws_vpc.demo-vpc.id

  tags = {
    Name = "demo-igw"
  }
}

resource "aws_route_table" "demo-rt" {
  vpc_id = aws_vpc.demo-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.demo-igw.id
  }

  tags = {
    Name = "demo-RT"
  }
}

resource "aws_route_table_association" "demo-rt-association" {
  subnet_id      = aws_subnet.demo-subnet.id
  route_table_id = aws_route_table.demo-rt.id
}

resource "aws_security_group" "demo-vpc-sg" {
  name        = "demo-vpc-sg"
  description = "demo-vpc-sg"
  vpc_id      = aws_vpc.demo-vpc.id

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

  ingress {
    description      = "SSH"
    from_port        = 22
    to_port          = 22
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
    Name = "demo-sg"
  }
}

resource "aws_instance" "demo-instance" {
  ami               = "ami-09278528675a8d54e"
  instance_type     = "t3.micro"
  availability_zone = "eu-north-1a"
  subnet_id         = aws_subnet.demo-subnet.id
  security_groups   = [aws_security_group.demo-vpc-sg.id]

  tags = {
    Name = "HelloWorld"
  }
}

resource "aws_s3_bucket" "demo-s3" {
  bucket = "myterraforms3bucketcloud"
}