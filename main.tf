# Configure the GitHub Provider in your root module!
# provider "github" {
# }

locals {
  letters = ["a","b","c","d","e","f","g","h","i","j","k","l","m","n","o","p","q","r","s","t","u","v","w","x","y","z"]
  az_list = flatten([
    for letter1 in local.letters : [
      for letter2 in local.letters : [
        upper(format("%s%s", letter1, letter2))
      ]
    ]
  ])

  app_names = [
    for az in slice(local.az_list,1,var.number_of_teams+1): format("app-%s", az)
  ]
  components = flatten([
    for app_name in local.app_names : [
      for i in range(1, var.number_of_components_per_team+1) : [
        format("%s-component-%02d", app_name, i)
      ]
    ]
  ])
}

resource "github_team" "teams" {
  for_each = toset(local.app_names)
  name = each.value
  privacy = "closed"
}

resource "github_repository" "repos" {
  for_each = toset(local.components)
  name = each.value
}

resource "github_team_repository" "team_repos" {
  for_each = toset(local.components)
  team_id    = github_team.teams[substr(each.value,0,6)].id
  repository = each.value
  permission = "maintain"
}

