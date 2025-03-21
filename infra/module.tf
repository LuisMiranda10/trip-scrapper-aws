module "network" {
  
  source = "git::https://github.com/DNXLabs/terraform-aws-network.git"
  # To use a specific version, replace <version> with the desired release (eg: 2.3.1):
  # source = "git::https://github.com/DNXLabs/terraform-aws-network.git?ref=<version>"

  name                  = "VPC-pipeline-trip-scrapper" #required
  vpc_cidr              = "10.1.0.0/16" #required

  # Add other module-specific variables here
  newbits               = 8             # will create /24 subnets
  multi_nat             = false
  max_az                = 1
  
}

module "github_oidc" {
  source = "git::https://github.com/DNXLabs/terraform-aws-vcs-oidc.git"

  identity_provider_url = "https://token.actions.githubusercontent.com"
  audiences             = [
    "sts.amazonaws.com"
  ]
  
  roles = [
    {
      name = "github-actions-miranda-pipeline"
      assume_roles = [
        "" #optional
      ]
      assume_policies = [
        "" #optional
      ]
      conditions = [
        {
          test = "ForAnyVAlue:StringLike"
          variable = "vstoken.actions.githubusercontent.com:sub"
          values = "repo:LuisMiranda10/*"
        }
      ]
    }
  ]

}

provider "aws" {
  region = "sa-east-1"
}