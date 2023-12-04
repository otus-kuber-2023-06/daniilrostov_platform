terraform {
  backend "http" {
    address = "https://gitlab.com/api/v4/projects/50800490/terraform/state/infra_state"
    lock_address = "https://gitlab.com/api/v4/projects/50800490/terraform/state/infra_state"
    unlock_address = "https://gitlab.com/api/v4/projects/50800490/terraform/state/infra_state"
  }
}
