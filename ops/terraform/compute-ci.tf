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

  # metadata {
  #   "block-project-ssh-keys" = "true"
  #   "ssh-keys" = "ytamura:ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC3KE9HoaQnrMapIlYgjS01dPMgw67NX17eEI8lqmCwzDy/GeR+MejZwQVB4EdqgyyE7KV1nCVya5uhsHrJaIclxtMWUthRGQV+th6aS0cBgJlp8cHiW4NS2XcF3iOGDhSiYp/CRXAU5yJ5loIEzI+pNV/Ns5INDLI8rNB0ZtLL/tmrnIaXWR8lD1/ia38/qZqZ+TO83SkLRAT5WpV3u089wdfk5kLeRekSgJfWqHRXN1/1CkckkMazURX0Y/oXi45kbbgEgmGZJbnz/qxcvmZwvO4IP+ImjQjS5H4AYhrhJ5CPVwRptqpyb5uy0hM2jfSkDnwC+UI3o8VWFBbQG+w7 a@qmu.jp"
  # }

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
