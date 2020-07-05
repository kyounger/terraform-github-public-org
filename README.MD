# Create GH teams, repos, and associate them together in an org

1. Create an empty public github org.

2. Not required, but I choose to create a github bot user for this public org and set it as an owner. This isolates my main github account from  potential exposure. Given this is a public org for public demo purposes, if the account were compromised somehow, I don't lose much by destroying everything.

3. Create a token that has access this org.

4. Create a simple `main.tf`:

   ```
   # specify values for the github provider in a provider block, or you can set:
   # GITHUB_TOKEN 
   # GITHUB_ORGANIZATION 
   # as environment variables and omit this entire provider block. reference: https://www.terraform.io/docs/providers/github/index.html#example-usage
   
   provider "github" {
     token        = "tokenvalue"
     organization = "public-org-name"
   }
   module "tf-gh-org" {
     source  = "github.com/kyounger/terraform-github-public-org"
   
     number_of_teams = 5
     number_of_components_per_team = 5
   }
   ```

   

5. Run: 

```
terraform init
terraform plan -out myplan
terraform apply myplan
```

All the variables are optional. They default to `5`, only for the sake of keeping the creation of these minimal; beware of github api limits!

Under the hood this module uses the [Terraform Github Provider](https://www.terraform.io/docs/providers/github/index.html). You can also specify the org name and token in environment variables. My approach is to specify the `organization` in the provider block and then specify the token in my current shell when running `plan` (or any other terraform command that will use it). Just be aware that you need to secure that credential.

```
export GITHUB_TOKEN=918723049871230948
terraform plan -out myplan
terraform apply myplan
```
