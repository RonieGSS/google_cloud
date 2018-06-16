variable "project" {default = "ronie-206608"}
variable "region" {default = "us-east1"}
variable "zone" {default = "us-east1-b"}
variable "cred" {default = "~/.ssh/ronie_google.json"}

provider "google" {
	credentials = "${file(var.cred)}"
	project = "${var.project}"
  region = "${var.region}"
}