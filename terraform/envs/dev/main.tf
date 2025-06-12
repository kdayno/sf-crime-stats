module "gcp" {
    source = "../../modules/gcp"
    env = var.env
    credentials = var.credentials
    project_name = var.project_name
    location = var.location
    region = var.region
}

# module "dbtcloud" {
#     source = "../../modules/dbtcloud"
#     env = var.env
#     tags = {
#         Environment = var.env
#         Project     = var.project_name
#     }
# }
