module "vpc" {
    source = "../../terraform-aws-vpc/vpc"
    project = var.project
    environment = var.environment
}
#https://github.com/ImManiKanta/terraform-modules.git?ref=main