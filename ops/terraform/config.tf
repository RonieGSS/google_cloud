variable "project" {default = "ronie-206608"}
variable "region" {default = "asia-southeast1"}
variable "zone" {default = "asia-southeast1-a"}
variable "ssh_key" {}
variable "user" {}
variable "cred" {}

provider "google" {
	credentials = "${file(var.cred)}"
	project = "${var.project}"
  region = "${var.region}"
}