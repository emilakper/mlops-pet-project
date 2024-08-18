resource "selectel_vpc_project_v2" "project_1" {
  name = var.project_name
}

resource "selectel_iam_serviceuser_v1" "serviceuser_1" {
  name = var.service_username
  password = var.password
  role {
    role_name = "member"
    scope = "project"
    project_id = selectel_vpc_project_v2.project_1.id
  }
}