locals {
  common_tags = {
    project = var.project
    environment = var.environment
    terraform = "true"
  }

  az_info = slice(data.aws_availability_zones.available.names, 0, 2)

}

