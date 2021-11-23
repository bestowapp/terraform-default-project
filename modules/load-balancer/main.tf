variable "cloud_dns_name" {
  type = string
}

variable "project_id" {
  type = string
}

variable "app_site_domain_name" {}

variable "public_site_domain_name" {}

variable "apple_app_site_association_backend_bucket_service" {}

variable "public_site_backend_bucket_service" {}

variable "service_account_email" {}

resource "google_compute_url_map" "default" {
  project = var.project_id

  name        = "www-url-map"
  description = "URL map for www"

  default_service = var.apple_app_site_association_backend_bucket_service

  host_rule {
    hosts        = [var.app_site_domain_name]
    path_matcher = "app-site"
  }

  path_matcher {
    name            = "app-site"
    default_service = var.apple_app_site_association_backend_bucket_service
  }

  host_rule {
    hosts        = [var.public_site_domain_name]
    path_matcher = "public-site"
  }

  path_matcher {
    name            = "public-site"
    default_service = var.public_site_backend_bucket_service
    path_rule {
      paths = ["/"]
      route_action {
        url_rewrite {
          path_prefix_rewrite = "/index.html"
        }
      }
      service = var.public_site_backend_bucket_service
    }
  }


}

resource "random_id" "certificate_name" {
  byte_length = 4
  prefix      = "load-balancer-cert-"

  keepers = {
    a = 2
  }
}

resource "google_compute_managed_ssl_certificate" "cert" {
  name    = random_id.certificate_name.hex
  project = var.project_id

  lifecycle {
    create_before_destroy = true
  }

  managed {
    domains = [var.app_site_domain_name, var.public_site_domain_name]
  }
}

module "lb" {
  source                = "github.com/gruntwork-io/terraform-google-load-balancer//modules/http-load-balancer"
  name                  = "default"
  project               = var.project_id
  url_map               = google_compute_url_map.default.self_link
  dns_managed_zone_name = var.cloud_dns_name
  custom_domain_names   = [var.app_site_domain_name, var.public_site_domain_name]
  create_dns_entries    = true
  enable_http           = true
  enable_ssl            = true
  ssl_certificates      = [google_compute_managed_ssl_certificate.cert.id]
}
