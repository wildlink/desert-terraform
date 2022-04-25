# Desert Terraform

This repository serves as an example repo of how a few simple DRY principles can dramatically
simplify management of resources with Terraform. There are three commits (and associated tags)
showing the improvements in layout and reduction in duplicated code that can be obtained with a few
simple steps. For more details, read our
[technical blog post](https://www.wildfire-corp.com/blog/desert-terraform-white-label-rewards-platform-dry-principles).

## Initial commit / tag:no-optimizations

This is a very naive approach to Terraform where no effort is made to share logic across
environments. Each resource has a bespoke file in the appropriate directory that fully defines that
resource. This results in significant duplication of logic and considerable attention to detail when
attempting to match up resources across environments.

## Second commit / tag:workspace-environment

This commit makes a first effort at improving the codebase by moving all the Terraform configuration
files up the directory tree to share basic configuration across the two environments. This cuts the
number of files in half and makes synchronizing setups for applications significantly easier. A
change to one workspace can quickly be tested and then migrated to another workspace.

## Third commit / tag:json-as-configuration

The final commit adds another level of configuration abstraction to the mix. Rather than duplicating
the same details for the majority of each resource, we can build a single <resource_type>.tf file
for each object class and then configure only the pieces the team needs to customize, eliminating
even more duplicated code!
