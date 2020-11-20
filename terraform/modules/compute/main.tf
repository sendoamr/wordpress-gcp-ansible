resource "google_compute_instance" "wordpress" {
  project      = "${var.project_name}"
  zone         = var.zone
  name         = "ce-wp-1"
  machine_type = "f1-micro"
  tags         = ["http-server"]

  boot_disk {
    initialize_params {
      image = "ubuntu-1604-xenial-v20181004"
    }
  }

  network_interface {
    network = "default"

    access_config {
      nat_ip = "X.X.X.X"
    }
  }

  provisioner "local-exec" {
    command = "sleep 20;ansible-playbook -i ${google_compute_instance.wordpress.network_interface.0.access_config.0.nat_ip}, ./ansible/playbook.yml -u sendoa"
  }

  labels = var.labels
}


resource "google_compute_firewall" "default" {
  name    = "nginx-firewall"
  network = "default"

  allow {
    protocol = "tcp"
    ports    = ["80"]
  }
}
