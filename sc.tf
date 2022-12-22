resource "aws_security_group" "web" {

  name = "web"

  description = "trafego aberto vindo de fora"

  vpc_id = aws_vpc.this.id

  ingress {
    cidr_blocks = ["0.0.0.0/0"]

    from_port = 80

    protocol = "tcp"

    to_port = 80
  }

  ingress {
    cidr_blocks = ["0.0.0.0/0"]

    from_port = 443

    protocol = "tcp"

    to_port = 443
  }

  ingress {
    cidr_blocks = ["0.0.0.0/0"]

    from_port = -1

    protocol = "icmp"

    to_port = -1
  }

  egress {

    from_port = 3306

    to_port = 3306

    protocol = "tcp"

    cidr_blocks = [aws_subnet.this["pvt_a"].cidr_block]
  }



  tags = merge(local.common_tags, { Name = "Servidor Web" })


}

resource "aws_security_group" "db" {

  name = "DataBase"

  description = "conexoes do banco vindas de fora"

  vpc_id = aws_vpc.this.id

  ingress {

    from_port = 3306

    protocol = "tcp"

    to_port = 3306

    security_groups = [aws_security_group.web.id]
  }

  ingress {
    cidr_blocks = [aws_vpc.this.cidr_block]

    from_port = 22

    protocol = "tcp"

    to_port = 22
  }

  ingress {

    cidr_blocks = [aws_vpc.this.cidr_block]

    from_port = -1

    protocol = "icmp"

    to_port = -1
  }

  egress {

    from_port = 22

    to_port = 22

    protocol = "tcp"

    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {

    from_port = 443

    to_port = 443

    protocol = "tcp"

    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(local.common_tags, { Name = "Servidor MYSQL" })


}

resource "aws_security_group" "alb" {

  name = "AWS-LOAD-BALANCER"

  description = "Load Balancer"

  vpc_id = aws_vpc.this.id


  ingress {
    from_port = 80

    to_port = 80

    protocol = "tcp"

    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port = 0

    to_port = 0

    protocol = -1

    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(local.common_tags, { Name = "Load Balancer" })
}

resource "aws_security_group" "autoscaling" {

  name = "autoscaling"

  description = "lb ssh e http"

  vpc_id = aws_vpc.this.id


  ingress {
    from_port = 22

    to_port = 22

    protocol = "tcp"

    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = 80

    to_port = 80

    protocol = "tcp"

    security_groups = [aws_security_group.alb.id]

  }

  egress {
    from_port = 0

    to_port = 0

    protocol = -1

    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(local.common_tags, { Name = "AutoScaling" })
}


resource "aws_security_group" "jenkins" {

  name = "jenkins"

  description = "conexoes vindas da maquina do jenkins"

  vpc_id = aws_vpc.this.id

  ingress {
    cidr_blocks = [aws_vpc.this.cidr_block]

    from_port = 22

    protocol = "tcp"

    to_port = 22
  }

  ingress {

    cidr_blocks = [aws_vpc.this.cidr_block]

    from_port = -1

    protocol = "icmp"

    to_port = -1
  }

  egress {

    from_port = 22

    to_port = 22

    protocol = "tcp"

    security_groups = [aws_security_group.web.id]

  }

  tags = merge(local.common_tags, { Name = "maquina jenkins" })


}