
provider "aws" {
  region = "ap-southeast-1"
}

data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  owners = ["099720109477"]
}

resource "aws_instance" "ec2-terraform" {
  count = 5
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t3.small"
  lifecycle {
    create_before_destroy = true
  }
}
output "ec2" {
  value = {
    public_ip = [ for v in aws_instance.ec2-terraform : v.public_ip ]
  }
}
