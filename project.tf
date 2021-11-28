module "default_project" {
  source            = "terraform-google-modules/project-factory/google"
  version           = "~> 11.2"
  org_id            = var.organization_id
  name              = local.project_name
#  random_project_id = true
  billing_account   = var.billing_account
  folder_id         = var.environment_folder_id
  group_name        = "gcp-organization-admins"
  activate_apis     = [
    "serviceusage.googleapis.com",
    "servicenetworking.googleapis.com",
    "compute.googleapis.com",
    "logging.googleapis.com",
    "bigquery.googleapis.com",
    "cloudresourcemanager.googleapis.com",
    "cloudbilling.googleapis.com",
    "iam.googleapis.com",
    "admin.googleapis.com",
    "appengine.googleapis.com",
    "storage-api.googleapis.com",
    "monitoring.googleapis.com",
    // default additions
    "firebase.googleapis.com",
    "clouddns.googleapis.com",
  ]
}
