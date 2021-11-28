locals {
  live_repo_name = "live-${local.project_name}"
}
resource "github_repository" "live_environment_group" {
  name = local.live_repo_name
  visibility = "private"
  template {
    owner      = "bestowapp"
    repository = "template-live-default-project-modules"
  }
}