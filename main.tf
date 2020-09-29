provider "azurerm" {
  features {}
  version = "~> 2.29.0"
}

locals {
  // simple array
  list = csvdecode(file("./resourceGroupNames.csv"))

  // use name as the key in a dictionary
  map = {
    for rg in csvdecode(file("./resourceGroupNames.csv")) :
    rg.name => rg
  }
}


resource "azurerm_resource_group" "rg" {
  for_each = local.map

  name     = each.key // could also be name = each.value.name
  location = each.value.region
  tags = {
    subscription     = each.value.subscription
    team             = each.value.team
    service_area     = each.value.service_area
    // constructed_name = join("-", ["syy-az", each.value.subscription, each.value.team, each.value.service_area, each.value.region, each.value.resource_type, format("%02d", each.value.instance_number)])
  }
}

output "list" {
  value = local.list
}

output "map" {
  value = local.map
}