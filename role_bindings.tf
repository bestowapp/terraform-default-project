locals {
  roles = toset([
    "roles/storage.admin", "roles/compute.loadBalancerAdmin", "roles/dns.admin", "roles/iam.securityAdmin",
    "roles/iam.serviceAccountAdmin", "roles/iam.serviceAccountKeyAdmin"
    #    "roles/firebase.admin", "roles/firebase.managementServiceAgent"
  ])
}
resource "google_project_iam_member" "default_service_account_membership" {
  project  = module.default_project.project_id
  for_each = local.roles
  role     = each.key
  member   = "serviceAccount:${module.default_project.service_account_email}"
}
