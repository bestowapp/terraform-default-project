
variable "project_id" {
  type = string
}

variable "service_account_email" {}

resource "random_integer" "bucket_id_suffix" {
  min = 100000
  max = 1000000
}

resource "google_storage_bucket" "public_site" {
  name          = "public-site-${random_integer.bucket_id_suffix.result}"
  location      = "US"
  force_destroy = true
  project       = var.project_id
}

resource "google_storage_default_object_acl" "website_acl" {
  bucket      = google_storage_bucket.public_site.id
  role_entity = ["READER:allUsers"]
}

resource "google_storage_bucket_object" "index" {
  name    = "index.html"
  content = "Coming soon"
  bucket  = google_storage_bucket.public_site.name

  # We have to depend on the ACL because otherwise the ACL could get created after the object
  depends_on = [google_storage_default_object_acl.website_acl]
}

resource "google_compute_backend_bucket" "public_site" {
  project     = var.project_id
  name        = "public-site"
  bucket_name = google_storage_bucket.public_site.name

}

output "backend_bucket_self_link" {
  value = google_compute_backend_bucket.public_site.self_link
}