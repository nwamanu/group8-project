#https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb
resource "aws_security_group" "allow_ssh" {
  name        = "allow_ssh"
  description = "Allow ssh inbound traffic"
  vpc_id      = aws_vpc.edgecontent.id

  ingress {
    description      = "ssh from me"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["71.140.144.180/32"] # allow my local machine to ssh
   
  }

# ingress {
#     description      = "http from me"
#     from_port        = 443
#     to_port          = 443
#     protocol         = "tcp"
#     cidr_blocks      = ["71.140.144.180/32"] 
   
  # }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  tags = {
    Name = "allow_ssh"
  }
}


#ec2 to test connectivity
resource "aws_instance" "web" {
  ami           = "ami-090fa75af13c156b4"

  instance_type = "t2.micro"
  subnet_id = aws_subnet.public-edgecontent.id
  vpc_security_group_ids = [aws_security_group.allow_ssh.id]
  key_name = "NovaRegionKey"

  tags = {
    Name = "edgeInstance"
  }
}

#sg for ALB 
resource "aws_security_group" "allow_http" {
  name        = "allow_hhtp"
  description = "Allow http inbound traffic"
  vpc_id      = aws_vpc.edgecontent.id

  ingress {
    description      = "http from me"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"] # allow my local machine to ssh
   
  }

ingress {
    description      = "https from me"
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"] 
   
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  tags = {
    Name = "allow_http"
  }
}


