data "aws_ami" "ubuntu" {

  owners = ["amazon"]

  most_recent = true

  name_regex = "ubuntu"

  filter {

    name   = "architecture"
    values = ["x86_64"]

  }

}

resource "aws_launch_template" "this" {

  name_prefix = "minicurso-terraform"

  image_id = data.aws_ami.ubuntu.id

  instance_type = "t3.micro"

  key_name = aws_key_pair.this.id

  user_data = filebase64("ec2.sh")

  monitoring {
    enabled = true

  }

  network_interfaces {

    associate_public_ip_address = true

    delete_on_termination = true

    security_groups = [aws_security_group.autoscaling.id]

  }

}

resource "aws_key_pair" "this" {
  key_name   = "terraform-key"
  public_key = ""
}



resource "aws_instance" "jenkins" {

  ami = data.aws_ami.ubuntu.id

  instance_type = "t3.micro"

  availability_zone = "us-east-1b"

  vpc_security_group_ids = [aws_security_group.jenkins.id]

  subnet_id = aws_subnet.this["pvt_b"].id


  tags = merge(local.common_tags, { Name = "Maquina jenkins" })


}
