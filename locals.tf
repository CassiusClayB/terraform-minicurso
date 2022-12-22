locals {

  subnet_ids = { for k, v in aws_subnet.this : v.tags.Name => v.id }



  common_tags = {

    project = "Minicurso AWS-TERRAFORM"

    CreatedAt = "2022-03-15"

    ManagedBy = "Terraform"

    Owner = "Cassius"

    Service = "Auto Scaling App"
  }
}