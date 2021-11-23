
variable "project_id" {
  type = string
}

variable "service_account_email" {}

resource "random_integer" "bucket_id_suffix" {
  min = 100000
  max = 1000000
}

resource "google_storage_bucket" "apple_app_site_association" {
  name          = "app-site-association-${random_integer.bucket_id_suffix.result}"
  location      = "US"
  force_destroy = true
  project       = var.project_id
}

resource "google_storage_default_object_acl" "website_acl" {
  bucket      = google_storage_bucket.apple_app_site_association.id
  role_entity = ["READER:allUsers"]
}

resource "google_storage_bucket_object" "index" {
  name    = "index.html"
  content = "Hello, World!"
  bucket  = google_storage_bucket.apple_app_site_association.name

  # We have to depend on the ACL because otherwise the ACL could get created after the object
  depends_on = [google_storage_default_object_acl.website_acl]
}

resource "google_storage_bucket_object" "apple_app_site_association" {
  name    = ".well-known/apple-app-site-association"
  content = file("${path.module}/apple-app-site-association.template.json")
  bucket  = google_storage_bucket.apple_app_site_association.name

  # We have to depend on the ACL because otherwise the ACL could get created after the object
  depends_on = [google_storage_default_object_acl.website_acl]
}

resource "google_compute_backend_bucket" "apple_app_site_association" {
  project     = var.project_id
  name        = "apple-app-site-association-backend-bucket"
  bucket_name = google_storage_bucket.apple_app_site_association.name
}



output "backend_bucket_self_link" {
  value = google_compute_backend_bucket.apple_app_site_association.self_link
}