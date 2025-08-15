resource "google_storage_bucket" "app_bucket" {
  name          = "${local.name_prefix}-bucket"
  location      = upper(var.region)
  force_destroy = false

  uniform_bucket_level_access = true

  versioning {
    enabled = true
  }
}

# Minimal Cloud SQL - MySQL, smallest shared-core tier for cost
resource "google_sql_database_instance" "primary" {
  name             = "${local.name_prefix}-mysql"
  database_version = "MYSQL_8_0"
  region           = var.region

  settings {
    tier = "db-f1-micro"

    ip_configuration {
      ipv4_enabled = true
      ssl_mode = "ALLOW_UNENCRYPTED_AND_ENCRYPTED"
    }

    backup_configuration {
      enabled = true
    }
  }
}

resource "google_sql_database" "app" {
  name     = "app"
  instance = google_sql_database_instance.primary.name
}

resource "random_password" "db" {
  length               = 16
  special              = true
  override_special     = "!@#%^*()-_=+"
}

resource "google_sql_user" "app" {
  name     = "appuser"
  instance = google_sql_database_instance.primary.name
  password = random_password.db.result
}

