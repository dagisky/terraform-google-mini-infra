# Enable Identity Platform basic email/password sign-in. Requires the API enabled.

resource "google_identity_platform_config" "default" {
  project = var.project_id
  provider = google
  autodelete_anonymous_users = true
  sign_in {
    email {
      enabled           = true
      password_required = true
    }
    anonymous {
      enabled = false
    }
    phone_number {
        enabled = true
        test_phone_numbers = {
            "+15153725040" = "000000"
        }
    }    
  }
  sms_region_config {
      allowlist_only {
        allowed_regions = [
          "US",
          "CA",
        ]
      }
  }
}

# Example OIDC provider wiring (commented). Fill with your provider details to enable.
# resource "google_identity_platform_oauth_idp_config" "oidc" {
#   provider              = "oidc.myprovider"
#   client_id             = "CLIENT_ID"
#   client_secret         = "CLIENT_SECRET"
#   issuer                = "https://issuer.example.com"
#   display_name          = "OIDC"
#   enabled               = true
#   response_type {
#     id_token = true
#   }
# }

