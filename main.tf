terraform {
  required_providers {
    github = {
      source  = "integrations/github"
      version = "4.23.0"
    }
  }
}

variable "repo" {
  type = string
  default = "gh-actions-repro"
}

variable "environment" {
  type = string
  default = "test"
}


locals {
  secrets = {
    encrypted_moderate_secret = "+AvOnfqMgFzQvPS0B/l0xfgk0xX04d9l6ehNsQlsVBZyHwmXYBm26JHq5NyhGOnM1QwqwoA8wgIhQDGtfzVDkxOUN6ZHFz59kR6YY9Ul",
    encrypted_minor_secret = "A+Vek8w1rVwqS1i1gotM+brmKRksu4bu7T9S2WIebUyqgiK+CWWpI5ohKceU01L2G/jasEUACOMwDJZfxV4pbed4MymDNDOLbPZA7/aMsfbVzogX5rcn"
  }
  plain = {
    plain_moderate_secret = "KFC's secret ingredient is MSG",
    plain_minor_secret = "Look behind you to find the exits at Ikea"
  }
}


resource "github_repository_environment" "this" {
  repository  = var.repo
  environment = var.environment
}

resource "github_actions_environment_secret" "dynamic_plain" {
  for_each = local.plain

  repository      = var.repo
  environment     = github_repository_environment.this.environment
  secret_name     = each.key
  plaintext_value = each.value
}

resource "github_actions_environment_secret" "dynamic_encrypted" {
  for_each = local.secrets

  repository      = var.repo
  environment     = github_repository_environment.this.environment
  secret_name     = each.key
  encrypted_value = each.value
}

resource "github_actions_environment_secret" "static" {
  repository      = var.repo
  environment     = github_repository_environment.this.environment
  secret_name     = "big_plain_secret"
  plaintext_value = "i kissed a girl and i liked it"
}

resource "github_actions_environment_secret" "static_encrypted" {
  repository      = var.repo
  environment     = github_repository_environment.this.environment
  secret_name     = "big_encrypted_secret"
  encrypted_value = "nzKeJOrLUCG5SwPQ8lmGyHB+qjCVxbMj1LnNYuBSSmw4i78mFfMmqX3VXmPVzurLTGEu+MHQEJZoXs2aKN1aTU6+185Cpm8JdfFLKQfn"
}
