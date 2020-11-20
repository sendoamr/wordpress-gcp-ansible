
variable "region" {
  default = "europe-west1"
}

variable "zone" {
  default = "europe-west1-b"
}


variable "project_name" {
  default = "wordpress-prueba"
}

variable "env" {
  default = "dev"
}

variable "labels" {
  default = {
    env     = "dev"
    project = "wordpress-prueba"
  }
}