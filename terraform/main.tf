# Configure the Google Cloud provider
provider "google" {
  project = var.project_name
  region  = var.region
}

# create source code bucket
resource "google_storage_bucket" "temp-bucket" {
  name          = "${var.project_name}-${var.env}-temp-bucket"
  location      = var.region
  force_destroy = true

  labels = var.labels
}


# Compute engine
module "compute" {
  source       = "./modules/compute"
  project_name = var.project_name
  region       = var.region
  zone         = var.zone
  labels       = var.labels
  env          = var.env
}

# Star and stop process
module "schedule" {
  source        = "./modules/schedule"
  project_name  = var.project_name
  region        = var.region
  zone          = var.zone
  labels        = var.labels
  env           = var.env
  temp-bucket   = google_storage_bucket.temp-bucket.name
  instance-name = module.compute.ce_instance
}