enable_nat_gateway = true

vpc_app_cidr = "10.0.0.0/16"
subnets_public = {
  "public-1a" = {
    "az"   = "us-east-1a",
    "cidr" = "10.0.0.0/24"
  },
  "public-1b" = {
    "az"   = "us-east-1b",
    "cidr" = "10.0.1.0/24"
  }
}
subnets_private_app = {
  "private-app-1a" = {
    "az"   = "us-east-1a",
    "cidr" = "10.0.10.0/24"
  },
  "private-app-1b" = {
    "az"   = "us-east-1b",
    "cidr" = "10.0.11.0/24"
  }
}
subnets_private_db = {
  "private-db-1a" = {
    "az"   = "us-east-1a",
    "cidr" = "10.0.20.0/24"
  },
  "private-db-1b" = {
    "az"   = "us-east-1b",
    "cidr" = "10.0.21.0/24"
  }
}