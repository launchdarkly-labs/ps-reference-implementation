Overview
---
This repository contains a series of directories containing detailed examples of how to configure the initial custom roles outlined in LaunchDarkly's Platform Readines via the Terraform provider. Click [here](https://registry.terraform.io/providers/launchdarkly/launchdarkly/latest/docs) for the official documentation on the Terraform website. 

> ! TAKE NOTE! Running terraform apply on any of these directories with your auth credentials will result in real resources being created that may cost real money. These are meant to be used as examples only and LaunchDarkly is not responsible for any costs incurred via testing.

Setup
--- 
Install Terraform
First and foremost, you need to make sure you have Terraform installed on the machine you will be applying the configurations from and that you meet the requirements listed on the [project readme](https://github.com/hashicorp/terraform-provider-launchdarkly#requirements). For instructions on how to install Terraform, see [here](https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli).


### Configure LD Credentials
Before getting started with the LaunchDarkly provider, you need to ensure you have your LaunchDarkly credentials properly set up. All you will need for this is a LaunchDarkly access token, which you can create via the LaunchDarkly platform under Account settings > Authorization.

Once you have your access token in hand, there are several ways to set variables within your Terraform context. For the sake of ease, we've set the access token as an environmental variable named LAUNCHDARKLY_ACCESS_TOKEN. The provider configuration will then automatically access it from your environment so that your provider config should only have to contain

```
provider "launchdarkly" {
  version = "~>2.0"
}
```
If you would prefer to define your variables some other way, see [Terraform's documentation on input variables](https://developer.hashicorp.com/terraform/tutorials/aws-get-started/aws-variables) for some other ways to do so.



Example: custom role
---

### Introduction
For enterprise customers, LaunchDarkly allows the configuration of custom roles to tailor user permissions. For more on these, see the [LaunchDarkly official documentation](https://docs.launchdarkly.com/home/members/custom-roles).

This directory provides an example a [custom role configuration](https://docs.launchdarkly.com/home/account-security/custom-roles/configure) that denies the user access to flags with the "terraform-managed" tag. For more information on tags in custom roles, see the [LaunchDarkly documentation](https://docs.launchdarkly.com/home/account-security/custom-roles/tags).

To add the tag to any of your Terraform-managed resources, you will need to ensure

```
tags = [
  "terraform-managed"
]
```
is added to all your resource configurations. Some examples can be found here.

### Run
Init your working directory from the CL with terraform init and then apply the changes with terraform apply. You should see output resembling the following:
```
launchdarkly_custom_role.excluding_terraform: Refreshing state... [id=excluding-terraform]

An execution plan has been generated and is shown below.
Resource actions are indicated with the following symbols:
  + create

Terraform will perform the following actions:

  # launchdarkly_custom_role.exclude_terraform will be created
  + resource "launchdarkly_custom_role" "exclude_terraform" {
      + description = "Deny access to resources with a 'terraform-managed' tag"
      + id          = (known after apply)
      + key         = "exclude-terraform"
      + name        = "Exclude Terraform"

      + policy {
          + actions   = [
              + "*",
            ]
          + effect    = "deny"
          + resources = [
              + "proj/*:env/:flag/*;terraform-managed",
            ]
        }
    }

Plan: 1 to add, 0 to change, 0 to destroy.
```
Terraform will then ask you for confirmation to apply the changes. If there are no issues, you should then see the following output:
```
launchdarkly_custom_role.exclude_terraform: Creating...
launchdarkly_custom_role.exclude_terraform: Creation complete after 1s [id=exclude-terraform]
```
You should then be able to confirm the creation of your custom role by navigating to the Account settings > Roles page within your LaunchDarkly dashboard, which should now have the "Exclude Terraform" role listed:

<img width="1038" alt="Screenshot 2023-02-23 at 12 47 11 PM" src="https://user-images.githubusercontent.com/114673814/221029857-7f570f50-905e-4652-9c5c-01c56efa9e1b.png">


To view the policy details, click on the role to expand:
<img width="977" alt="Screenshot 2023-02-23 at 12 49 42 PM" src="https://user-images.githubusercontent.com/114673814/221029823-4e860fa0-a573-4646-b842-94c9ee000b75.png">

How to Use
---

### Overview
When creating intial custom roles for your LaunchDarkly instance, we have seen two approaches work well across organizations of various size and scale. 
1. Per Environment
     This approach will create the intial custom roles within each environment. If you have 3 LaunchDarkly environments (Dev, QA, and Production) it would create the Release Manager role as Release Manager Dev, Release Manager QA, and Release Manager Production.

     Creating the intial custom roles on a per environment basis would be beneficial if you wish to give your organization fine grain access control over each environment.

2. Preproduction vs Production
     This approach will create a set of the intial custom roles in your LaunchDarkly production environment and another set of initial custom roles in all other environments (aka Preproduction). If you have 3 LaunchDarkly environments (Dev, QA, and Production) it would create the Release Manager role as Release Manager Production (covering the production environemnt) and Release Manager Preproduction (covering Dev & QA environments).

     Creating the intial custom roles on a production and preproduction basis allows your organization to have more tightly controlled production environment compared to your other environemnts.

However, each organization is different and has their own set of use cases and security requirements.  Please take this into consideration before deciding on an approach.

*If you took part in a paid Platform Readiness engagement, a decision on which approach to take should have been made during the engagement in consultation with the attendees.*

### Implementing Per Environment Initial Custom Roles
In order to implement the per environment approach for the intial custom roles, you will need to make the following modifications to the `main.tf` file.
1. Clone this repo or download the zip locally
2. Open `main.tf`
3. Remove or comment out lines 69-93 (`module "preproduction-production-roles"`)
4. Under `module "default-project-roles"`
  * Update `project` key and name to reflect your project key and project name
  * Update  `environment` to reflect your environment keys and environment names. You may need to make additional entries to account for all your environments.
5. Save
6. Follow the steps listed above under [Run](https://github.com/launchdarkly-labs/ps-reference-implementation#run)

### Implementing Production vs Preproduction Initial Custom Roles
In order to implement the Production vs. Preproduction approach for the intial custom roles, you will need to make the following modifications to the `main.tf` file.
1. Clone this repo or download the zip locally
2. Open `main.tf`
3. Remove or comment out lines 27-43 (`module "default-project-roles"`)
4. Under `module "preproduction-production-roles"`
  * Update `project` key and name to reflect your project key and project name
  * If your production environment is named something other than Production, you will need to make this update on lines 58 & 86
5. Save
6. Follow the steps listed above under [Run](https://github.com/launchdarkly-labs/ps-reference-implementation#run)
