# Terraform Beginner Bootcamp 2023 -  (WEEK 1)

## Table of contents
- [Root Module Structure](#root-module-structure)
- [Terraform Variables and Outputs](#terraform-variables-and-outputs)
  * [Terraform Cloud Variables](#terraform-cloud-variables)
  * [Loading Terraform Input Variables](#loading-terraform-input-variables)
  * [var flag](#var-flag)
  * [var-file flag](#var-file-flag)
  * [terraform.tfvars](#terraformtfvars)
  * [auto.tfvars](#autotfvars)
  * [Order of terraform variables](#order-of-terraform-variables)
- [Dealing With Configuration Drift](#dealing-with-configuration-drift)
  * [What happens if we lose our state file?](#what-happens-if-we-lose-our-state-file-)
  * [Fix Missing Resources with Terraform Import](#fix-missing-resources-with-terraform-import)
  * [Fix Manual Configuration](#fix-manual-configuration)

<small><i><a href='http://ecotrust-canada.github.io/markdown-toc/'>Table of contents generated with markdown-toc</a></i></small>


## Root Module Structure

Our root module structure is as follows:

```
PROJECT_ROOT
│
├── main.tf                 # everything else.
├── variables.tf            # stores the structure of input variables
├── terraform.tfvars        # the data of variables we want to load into our terraform project
├── providers.tf            # defined required providers and their configuration
├── outputs.tf              # stores our outputs
└── README.md               # required for root modules
```

[Standard Module Structure](https://developer.hashicorp.com/terraform/language/modules/develop/structure)

## Terraform Variables and Outputs

### Terraform Cloud Variables

In terraform we can set two kind of variables:
- Enviroment Variables - those you would set in your bash terminal eg. AWS credentials
- Terraform Variables - those that you would normally set in your tfvars file

We can set Terraform Cloud variables to be sensitive so they are not shown visibliy in the UI.

### Loading Terraform Input Variables

[Terraform Input Variables](https://developer.hashicorp.com/terraform/language/values/variables)

### var flag
We can use the `-var` flag to set an input variable or override a variable in the tfvars file eg. `terraform -var user_ud="my-user_id"`

### var-file flag

The Terraform `var-file` flag is used to pass variables to Terraform from a file. This can be useful for passing sensitive data or for passing a large number of variables.

The `var-file` flag can be used with any Terraform command that supports variables. To use the var-file flag, simply pass the path to the variable file as the argument to the flag.

For example, to apply a Terraform configuration using the variables in the file terraform.tfvars, we would use the following command:

```terraform apply -var-file=variables.tfvars```
Terraform will use the values of the variables in the terraform.tfvars file to create the instance.

The `var-file` flag is a powerful tool that can be used to make your Terraform configurations more convenient, readable, and maintainable.

[Refer the Documentation](https://developer.hashicorp.com/terraform/language/values/variables)

### terraform.tfvars

A `terraform.tfvars` file is a file that contains variables for Terraform to use. It is a simple text file that uses the HashiCorp Configuration Language (HCL) syntax.

Each variable in a terraform.tfvars file is defined on a new line, in the following format:

```variable_name = value```
The variable_name is the name of the variable and the value is the value of the variable.

### auto.tfvars

Terraform `auto.tfvars` files are a special type of variable file that are automatically loaded by Terraform. `auto.tfvars` files are useful for storing variables that are shared between multiple Terraform configurations or that need to be kept secret.

To create an auto.tfvars file, simply create a file with the `.auto.tfvars` extension. `auto.tfvars` files must be placed in the same directory as the Terraform configuration file that uses them.

### Order of terraform variables

The order of precedence for Terraform variables is as follows, from highest to lowest:

1. Environment variables (TF_VAR_variable_name)
2. The terraform.tfvars file
3. The terraform.tfvars.json file
4. Any *.auto.tfvars or *.auto.tfvars.json files, processed in lexical order of their filenames
5. Any -var and -var-file options on the command line, in the order they are provided
6. Variable defaults

This order of precedence can be useful for overriding the values of variables from the command line or from environment variables.
## Dealing With Configuration Drift

### What happens if we lose our state file?

If you lose your statefile, you most likley have to tear down all your cloud infrastructure manually.

You can use terraform port but it won't for all cloud resources. You need check the terraform providers documentation for which resources support import.

### Fix Missing Resources with Terraform Import

`terraform import aws_s3_bucket.bucket bucket-name`

[Terraform Import](https://developer.hashicorp.com/terraform/cli/import)
[AWS S3 Bucket Import](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket#import)

### Fix Manual Configuration

If someone goes and delete or modifies cloud resource manually through ClickOps. 
If we run Terraform plan is with attempt to put our infrstraucture back into the expected state fixing Configuration Drift
### Fix using Terraform Refresh
Terraform refresh is a command that updates Terraform's state to match the actual state of your infrastructure. It is important to run Terraform refresh before applying any changes to your infrastructure, as this will help to ensure that Terraform is aware of any changes that have been made outside of Terraform.

```sh
terraform apply -refresh-only -auto-approve
```
Terraform will then read the current settings from all managed remote objects and update the state to match.

## Terraform Modules
Modules are containers for multiple resources that are used together. A module consists of a collection of .tf and/or .tf.json files kept together in a directory.

Modules are the main way to package and reuse resource configurations with Terraform.

### Terraform Module Structure
Every Terraform configuration has at least one module, known as its root module, which consists of the resources defined in the `.tf` files in the main working directory.
It is recommend to place modules in a `modules` directory when locally developing modules but you can name it whatever you like.

### Passing Input Variables

We can pass input variables to our module.
The module has to declare the terraform variables in its own variables.tf
In our project the example is shown below:

```tf
module "terrahouse_aws" {
  source = "./modules/terrahouse_aws"
  user_uuid = var.user_uuid
  bucket_name = var.bucket_name
}
```

### Modules Sources
The `source` argument in a module block tells Terraform where to find the source code for the desired child module.

Terraform uses this during the module installation step of `terraform init` to download the source code to a directory on local disk so that other Terraform commands can use it.

Using the source we can import the module from various places eg:
- locally
- Github
- Terraform Registry

```tf
module "terrahouse_aws" {
  source = "./modules/terrahouse_aws"
}
```
[Official Documentation for Modules Sources](https://developer.hashicorp.com/terraform/language/modules/sources)

## Considerations when using ChatGPT to write Terraform

LLMs such as ChatGPT may not be trained on the latest documentation or information about Terraform.

It may likely produce older examples that could be deprecated. Often affecting providers.

## Working with Files in Terraform


### Fileexists function

This is a built in terraform function to check the existance of a file.

```tf
condition = fileexists(var.error_html_filepath)
```

https://developer.hashicorp.com/terraform/language/functions/fileexists

### Filemd5

https://developer.hashicorp.com/terraform/language/functions/filemd5

### Path Variable

In terraform there is a special variable called `path` that allows us to reference local paths:
- path.module = get the path for the current module
- path.root = get the path for the root module
[Special Path Variable](https://developer.hashicorp.com/terraform/language/expressions/references#filesystem-and-workspace-info)


resource "aws_s3_object" "index_html" {
  bucket = aws_s3_bucket.website_bucket.bucket
  key    = "index.html"
  source = "${path.root}/public/index.html"
}

## Terraform Locals

Locals allows us to define local variables.
It can be very useful when we need transform data into another format and have referenced a varaible.

```tf
locals {
  s3_origin_id = "MyS3Origin"
}
```
[Local Values](https://developer.hashicorp.com/terraform/language/values/locals)

## Terraform Data Sources

This allows use to source data from cloud resources.

This is useful when we want to reference cloud resources without importing them.

```tf
data "aws_caller_identity" "current" {}

output "account_id" {
  value = data.aws_caller_identity.current.account_id
}
```
[Data Sources](https://developer.hashicorp.com/terraform/language/data-sources)

## Working with JSON

We use the jsonencode to create the json policy inline in the hcl.

```tf
> jsonencode({"hello"="world"})
{"hello":"world"}
```

[jsonencode](https://developer.hashicorp.com/terraform/language/functions/jsonencode)