module "bucket" {
  source = "./modules/bucket"
}

module "droplet" {
  source       = "./modules/droplet"
  ssh_key_name = var.ssh_key_name
}

module "database" {
  source = "./modules/database"
}

module "project" {
  source    = "./modules/project"
  resources = [module.droplet.urn, module.bucket.urn, module.database.urn]
}
