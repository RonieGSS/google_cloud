# = = = = = = = = = = = = = = = = = = = = = = 
# IP
# = = = = = = = = = = = = = = = = = = = = = = 

resource "google_compute_address" "compute-ci" {
  name = "ronie-jenkins"
  region = "us-east1"
  address_type = "EXTERNAL"  
}

# = = = = = = = = = = = = = = = = = = = = = = 
# Firewall
# = = = = = = = = = = = = = = = = = = = = = = 

resource "google_compute_firewall" "compute-ci" {
  name    = "compute-ci"
  network = "default"
  allow {
    protocol = "tcp"
    ports    = ["80", "443"]
  }
  allow {
    protocol = "udp"
    ports    = ["60000", "60001", "60002"]
  }
  target_tags = ["${google_compute_instance.compute-ci.tags}"]
}

# = = = = = = = = = = = = = = = = = = = = = = 
# instance
# = = = = = = = = = = = = = = = = = = = = = = 

resource "google_compute_instance" "compute-ci" {
  name         = "compute-ci"
  zone         = "${var.zone}"
  machine_type = "n1-standard-1"

  tags = ["compute-ci"]

  boot_disk {
    auto_delete = "false"
    source      = "${google_compute_disk.compute-ci.self_link}"
  }

  network_interface {
    network = "default"

    access_config {
      nat_ip = "${google_compute_address.compute-ci.address}"
    }
  }

  metadata {
    "block-project-ssh-keys" = "true"
    "ssh-keys" = "${var.user}:${var.ssh_key}"
  }

  service_account {
    scopes = ["userinfo-email", "compute-ro", "storage-ro"]
  }
}


# = = = = = = = = = = = = = = = = = = = = = = 
# disk
# = = = = = = = = = = = = = = = = = = = = = = 

resource "google_compute_disk" "compute-ci" {
  name  = "compute-ci-disk"
  type  = "pd-standard"
  zone  = "${var.zone}"
  size  = "20"
  image = "https://www.googleapis.com/compute/v1/projects/ubuntu-os-cloud/global/images/ubuntu-1704-zesty-v20171208"
  labels {
    environment = "compute-ci"
  }
}
