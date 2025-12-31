provider "vault" {
  address = "https://vault.lab.kvd.studio"
}

provider "infisical" {
  host = "https://infisical.lab.kvd.studio"
}

data "infisical_secrets" "default" {
  env_slug     = var.infisical_env
  folder_path  = "/"
  workspace_id = jsondecode(file("./.infisical.json"))["workspaceId"]
}

provider "postgresql" {
  host     = data.infisical_secrets.default.secrets["DB_HOST"].value
  port     = data.infisical_secrets.default.secrets["DB_PORT"].value
  database = data.infisical_secrets.default.secrets["DB_DATABASE"].value
  username = data.infisical_secrets.default.secrets["DB_USER"].value
  password = data.infisical_secrets.default.secrets["DB_PASSWORD"].value
  sslmode  = "disable"
}

resource "postgresql_role" "inf_test" {
  name                      = "inf_test_user"
  replication               = false
  login                     = true
  password_wo               = data.infisical_secrets.default.secrets["INF_TEST_USER_PASSWORD"].value
  password_wo_version       = "1"
  bypass_row_level_security = false
}

resource "postgresql_database" "inf_test" {
  name                   = "inf_test"
  owner                  = postgresql_role.inf_test.name
  alter_object_ownership = true
}
