provider "aws"{
    region = "af-south-1"
    
}

resource "aws_default_vpc" "default" {
     tags = {
        Name = "Default VPC"
     }
}

data "aws_availability_zones" "available" {
  state = "available"
}


resource "aws_default_subnet" "default_az1" {
  availability_zone = data.aws_availability_zones.available.names[0]

  tags = {
    Name = "Default subnet for af-south-1a"
  }
}

resource "aws_security_group" "allow_tls" {
  name        = "allow_tls"
  description = "Allow 8080 and 22 inbound traffic"
  vpc_id      = aws_default_vpc.default.id

  ingress {
    description      = "ssh access"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    
  }

  ingress {
    description      = "http access"
    from_port        = 8080
    to_port          = 8080
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
    Name = "allow_tls"
  }
}

resource "aws_instance" "Jenkins" {
  ami           ="ami-053b0d53c279acc90"
  instance_type = "t2.micro"
  subnet_id = aws_default_subnet.default_az1.id
  vpc_security_group_ids = [aws_security_group.allow_tls.id]
  key_name   = "tobi_key"

  tags = {
    "Name" = "Jenkins_server" 
  }

}
resource "null_resource" "name" {
  # SSH into Ec2 instance 

  connection {

    type = "ssh" 
    user = "ubuntu"
    private_key = file("~/Downloads/tobi_key.pem")
    host = aws_instance.Jenkins.public_ip 
  }

  # copy nad install jenkins.sh file from local to ec2 instance 

  provisioner "file"{
    source = "install_jenkins.sh"
    destination = "/tmp/install_jenkins.sh"

  }
  # set permission and execute the install_jenkins.sh file 
  provisioner "remote-exec"{
    inline = [
      "sudo chmod +x /tmp/install_jenkins.sh",
      "sh/tmp/install_jenkins.sh"
   
   ]
  
  }
  depends_on = [
    aws_instance.Jenkins 
  ]
} 
