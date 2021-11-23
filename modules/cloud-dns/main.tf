variable "project_id" {}
variable "domain_name" {}

module "cloud_dns" {
  source     = "github.com/terraform-google-modules/terraform-google-cloud-dns//."
  domain     = "${var.domain_name}."
  name       = "public-dns"
  project_id = var.project_id
  type       = "public"
}

output "cloud_dns_name" {
  value = module.cloud_dns.name
}