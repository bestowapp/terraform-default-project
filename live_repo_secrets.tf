
locals {
  secrets = tomap({
    "billing_account" : var.billing_account,
    "domain_name": var.domain_name,
    "environment_name": var.environment_name,
    "group_name": var.group_name,
    "name" : var.name,
    "organization_id" : var.organization_id,
    "project_id" : module.default_project.project_id,
    "service_account_email" : module.default_project.service_account_email,
    "service_account_id" : module.default_project.service_account_id,
    "state_bucket_name" : google_storage_bucket.state.name,
  })
}

resource "github_actions_secret" "bucket_name" {
  repository      = github_repository.live_environment_group.name
  for_each        = local.secrets
  secret_name     = each.key
  plaintext_value = each.value
}


