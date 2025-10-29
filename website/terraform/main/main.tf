module "project" {
  source = "./modules/project"
}

module "bucket" {
  source     = "./modules/bucket"
  depends_on = [module.project]
}

module "droplet" {
  source       = "./modules/droplet"
  ssh_key_name = var.ssh_key_name
  depends_on   = [module.project]
}

# module "database" {
#   source     = "./modules/database"
#   depends_on = [module.project]
# }

resource "digitalocean_project_resources" "aaaaaa" {
  depends_on = [module.bucket, module.droplet, module.project]
  project    = module.project.id
  resources  = [module.droplet.urn, module.bucket.urn]
}
