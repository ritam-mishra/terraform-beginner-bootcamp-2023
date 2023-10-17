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