# Terraform Beginner Bootcamp 2023 -  (WEEK 0)
## Table of contents
- [Semantic Versioning](#semantic-versioning)
- [Installing the Terraform CLI](#installing-the-terraform-cli)
  * [Documenting the changes made to the Terraform CLI](#documenting-the-changes-made-to-the-terraform-cli)
  * [Considerations for Linux Distribution](#considerations-for-linux-distribution)
  * [Refactoring the Bash Scripts](#refactoring-the-bash-scripts)
    + [Introduction to Shebang](#introduction-to-shebang)
    + [Execution Considerations](#execution-considerations)
    + [Linux Permissions Considerations](#linux-permissions-considerations)
  * [Gitpod Lifecycle Considerations](#gitpod-lifecycle-considerations)
- [Documenting about Environmental Variables](#documenting-about-environmental-variables)
  * [env command](#env-command)
  * [Setting and Unsetting Env Vars](#setting-and-unsetting-env-vars)
  * [Printing Vars](#printing-vars)
  * [Scoping of Env Vars](#scoping-of-env-vars)
  * [Persisting Env Vars in Gitpod](#persisting-env-vars-in-gitpod)
- [Installing the AWS CLI](#installing-the-aws-cli)
- [Working with Terraform](#working-with-terraform)
  * [Terraform Registry](#terraform-registry)
  * [Terraform Console](#terraform-console)
    + [Terraform Init](#terraform-init)
    + [Terraform Plan](#terraform-plan)
    + [Terraform Apply](#terraform-apply)
    + [Terraform Destroy](#terraform-destroy)
  * [Terraform Lock Files](#terraform-lock-files)
  * [Terraform State Files](#terraform-state-files)
  * [Terraform Directory](#terraform-directory)
- [Terraform Cloud Login and Gitpod Workspace](#terraform-cloud-login-and-gitpod-workspace)
- [Providing the right credentials for AWS Provider](#providing-the-right-credentials-for-aws-provider)
- [Automation of generation of tfrc file](#automation-of-generation-of-tfrc-file)


## Semantic Versioning

This project is going utilize semantic versioning for its tagging.
<br>For reference, go to the official website of semantic versioning- 
[semver.org](https://semver.org/)

The general format of semantic versioning is shown below:
 **MAJOR.MINOR.PATCH**, eg. `1.0.1`

- **MAJOR** version when you make incompatible API changes
- **MINOR** version when you add functionality in a backward compatible manner
- **PATCH** version when you make backward compatible bug fixes

## Installing the Terraform CLI

### Documenting the changes made to the Terraform CLI
The Terraform CLI installation instructions have changed due to gpg keyring changes. So we needed refer to the latest CLI installing instructions via Terraform Documentation and change the scripting for installation.

[Install Terraform CLI](https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli)


### Considerations for Linux Distribution

Our project is built against Ubuntu.

Note: We should always consider to check our Linux Distribution and change the distribution accordingly to our needs. 

[How To Check OS Version in Linux](
https://www.cyberciti.biz/faq/how-to-check-os-version-in-linux-command-line/)

Example of checking OS Version:

```sh
$ cat /etc/os-release

    PRETTY_NAME="Ubuntu 22.04.3 LTS"
    NAME="Ubuntu"
    VERSION_ID="22.04"
    VERSION="22.04.3 LTS (Jammy Jellyfish)"
    VERSION_CODENAME=jammy
    ID=ubuntu
    ID_LIKE=debian
    HOME_URL="https://www.ubuntu.com/"
    SUPPORT_URL="https://help.ubuntu.com/"
    BUG_REPORT_URL="https://bugs.launchpad.net/ubuntu/"
    PRIVACY_POLICY_URL="https://www.ubuntu.com/legal/terms-and-policies/privacy-policy"
    UBUNTU_CODENAME=jammy
```

### Refactoring the Bash Scripts

While fixing the Terraform CLI gpg depreciation issues we noticed that there were considerably good amount of codes to install the Terraform CLI. So we decided to create a bash script to install the Terraform CLI.

This bash script is located here: [./bin/install_terraform_cli](./bin/install_terraform_cli)

- This will keep the Gitpod Task File ([.gitpod.yml](.gitpod.yml)) tidy.
- This allow us an easier to debug and execute manually Terraform CLI install
- This will allow better portability for other projects that need to install Terraform CLI.

#### Introduction to Shebang

A Shebang (pronounced Sha-bang) tells the bash script what program that will interpret the script. eg. `#!/bin/bash`

The advantage of using the shebang is too goo
- for portability for different OS distributions 
-  will search the user's PATH for the bash executable

[Read more about Shebang](https://en.wikipedia.org/wiki/Shebang_(Unix))

#### Execution Considerations

When executing the bash script we can use the `./` shorthand notation to execute the bash script.

eg. `./bin/install_terraform_cli`

If we are using a script in .gitpod.yml  we need to point the script to a program to interpret it.

eg. `source ./bin/install_terraform_cli`

#### Linux Permissions Considerations

In order to make our bash scripts executable we need to change linux permission for the fix to be executable at the user mode.

```sh
chmod u+x ./bin/install_terraform_cli
```

alternatively, we can also use the numbered format:

```sh
chmod 744 ./bin/install_terraform_cli
```

https://en.wikipedia.org/wiki/Chmod

### Gitpod Lifecycle Considerations

We need to be careful when using the Init because it will not rerun if we restart an existing workspace.
Gitpod executes the `before` and most importantly, `init` tasks automatically for each new commit to your project.

https://www.gitpod.io/docs/configure/workspaces/tasks

## Documenting about Environmental Variables

### env command

We can list out all Enviroment Variables (Env Vars) using the `env` command
We can filter specific env vars using grep eg. `env | grep AWS_`

### Setting and Unsetting Env Vars

In the terminal we can set using `export HELLO='world`
In the terrminal we unset using `unset HELLO`

We can set an env var temporarily when just running a command:
```sh
HELLO='world' ./bin/print_message
```

Within a bash script we can set env without writing export eg.

```sh
#!/usr/bin/env bash

HELLO='world'

echo $HELLO
```

### Printing Vars

We can print an env var using echo eg. `echo $HELLO`

### Scoping of Env Vars

When we open up new bash terminals in VSCode it will not be aware of env vars that you have set in another window.

If you want to Env Vars to persist across all future bash terminals that are open you need to set env vars in your bash profile. eg. `.bash_profile`

### Persisting Env Vars in Gitpod

We can persist env vars into gitpod by storing them in Gitpod Secrets Storage.

```
gp env HELLO='world'
```

All future workspaces launched will set the env vars for all bash terminals opened in thoes workspaces.
We can also set env vars in the `.gitpod.yml` but this can only contain non-senstive env vars.

## Installing the AWS CLI

AWS CLI is installed for the project via the bash script [`./bin/install_aws_cli`](./bin/install_aws_cli)


[Getting Started Install (AWS CLI)](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html)
[AWS CLI Env Vars](https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-envvars.html)

To generate security credentials for our AWS accounts, we need to go to:

```mermaid
flowchart TD
    IAM --> Users --> Security Credentials --> Set Access Keys
```
We'll need to generate AWS CLI credits from IAM User in order to the user AWS CLI.
We are going to export the values of secret and screet aws credentials .
We can check if our AWS credentials is configured correctly by running the following AWS CLI command:

```sh
aws sts get-caller-identity
```

If it is succesful you should see a json payload return that looks like this:

```json
{
    "UserId": "AIEAVUO15ZPVHJ5WIJ5KR",
    "Account": "123456789012",
    "Arn": "arn:aws:iam::123456789012:user/terraform-beginner-bootcamp"
}
```
The two lines of code:
```sh
rm -f '/workspace/awscliv2.zip'
rm -rf '/workspace/aws'
```
ensures that the installation of aws cli restarts without user input.

## Working with Terraform

### Terraform Registry

Terraform sources their providers and modules from the Terraform registry which located at [registry.terraform.io](https://registry.terraform.io/)

- **Providers** in Terraform are a plugin that enable interaction with an API. This includes Cloud providers and Software-as-a-service providers. The providers are specified in the Terraform configuration code. They tell Terraform which services it needs to interact with
- **Modules** are containers for multiple resources that are used together in configurations. They help to make large amount of terraform code modular, portable and shareable.

[Random Terraform Provider](https://registry.terraform.io/providers/hashicorp/random)

### Terraform Console

We can see a list of all the Terraform commands by simply typing `terraform`


#### Terraform Init

At the start of a new terraform project we will run `terraform init` to download the binaries for the terraform providers that we'll use in this project.

#### Terraform Plan

`terraform plan`

This will generate out a changeset, about the state of our infrastructure and what will be changed.

This command lets us know all the list of actions that terraform will execute in order to reach to the desired state

#### Terraform Apply

`terraform apply`

This will run a plan and pass the changeset to be execute by terraform. Apply should prompt yes or no.

If we want to automatically approve an apply we can provide the auto approve flag eg. `terraform apply --auto-approve`

#### Terraform Destroy

`teraform destroy`
The terraform destroy command terminates resources managed by your Terraform project. This command is the inverse of terraform apply in that it terminates all the resources specified in your Terraform state. It does not destroy resources running elsewhere that are not managed by the current Terraform project.

You can alos use the auto approve flag to skip the approve prompt eg. `terraform apply --auto-approve`

### Terraform Lock Files

`.terraform.lock.hcl` contains the locked versioning for the providers or modules that should be used with this project.

The Terraform Lock File **should be committed** to your Version Control System (VSC) eg. Github

### Terraform State Files

`.terraform.tfstate` is created after running terraform apply . The actual content of this file is a JSON formatted mapping of the resources defined in the configuration and those that exist in your infrastructure.

This file **should not be commited** to your VCS.

This file can contain sensitive data.
Losing state file means Terraform loses track of the infrastructure that exists. 

`.terraform.tfstate.backup` is the previous state file state.

### Terraform Directory

`.terraform` directory contains binaries of terraform providers.

## Terraform Cloud Login and Gitpod Workspace
To work with the `terraform login`, we need to first manually generate a token in Terraform Cloud. Then we need to provide the token as an input after navigating to P)rint after we run the command ```terraform login```

To generate a token manually in terraform cloud we can go to [This link](https://app.terraform.io/app/settings/tokens?source=terraform-login) and create an API token for our workspace to get authenticated 

**ALTERNATIVELY**,
We can create a file manually and store our generated token by using the below commands:


```sh
touch /home/gitpod/.terraform.d/credentials.tfrc.json
open /home/gitpod/.terraform.d/credentials.tfrc.json
```

Provide the following code (replace your token in the file):

```json
{
  "credentials": {
    "app.terraform.io": {
      "token": "YOUR-TERRAFORM-CLOUD-TOKEN"
    }
  }
}
```
We can then successfully run the `terraform apply` command to plan the resources successfully.

## Providing the right credentials for AWS Provider

When running the `terraform plan` command, we can run into a problem of credentials failed. We need to carefully include the 
```
provider "aws" {
  region     = "us-west-2"
  access_key = "my-access-key"
  secret_key = "my-secret-key"
}
```
code in our `main.tf` file and provide the correct values of AWS in order to get over the credentials failed error that might occur after running the `terraform plan`.

- **NOTE: WE SHOULD NEVER COMMIT THIS `main.tf` file WITH THE AWS CREDENTIALS PROVIDED. THIS MIGHT RESULT IN COMPROMISING THE AWS CREDENTIALS TO A PUBLIC REPO.**

- **ALWAYS DELETE THE AWS PROVIDER CREDENTIAL CODE BEFORE COMMITING THE  `main.tf` FILE. IT IS A SECURITY BEST PRACTICE.**

## Automation of generation of tfrc file
We have used chatGPT to generate a [generate_tfrc_credentials](./bin/generate_tfrc_credentials) file where we have automated the login process of the terraform using the API token authentication. 

We then changed the `gitpod.yml` file such that the authentication happens as soon as we reopen/start a new workspace.