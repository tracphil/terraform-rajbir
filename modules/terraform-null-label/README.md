
# Terraform Module: terraform-null-label

This Terraform module is designed to help generate consistent names and tags for resources. Use `terraform-null-label` to implement a strict naming convention.

A label follows the following convention: `{namespace}-{account}-{stage}-{name}-{attributes}`. The delimiter is configurable as well.
The label items are all optional. So if you prefer to use `stage` to `account` you can exclude account and the label `id` will look like `{namespace}-{stage}-{name}-{attributes}`.
If attributes are excluded but `stage` and `account` are included, `id` will look like `{namespace}-{account}-{stage}-{name}`

It is recommended to use one `terraform-null-label` module for every unique resource of a given resource type.
For example, if you have 10 instances, there should be 10 different labels.
However, if you have multiple different kinds of resources (e.g. instances, security groups, file systems, and elastic ips), then they can all share the same label assuming they are logically related.

All [Mantoso Terraform modules](https://github.com/mantoso?utf8=%E2%9C%93&q=terraform-&type=&language=) use this module to ensure resources can be instantiated multiple times within an account and without conflict.

**NOTE:** The `null` refers to the primary Terraform [provider](https://www.terraform.io/docs/providers/null/index.html) used in this module.

## Usage

**IMPORTANT:** The `master` branch is used in `source` just as an example. In your code, do not pin to `master` because there may be breaking changes between releases.
Instead pin to the release tag of one of the [latest releases](https://github.com/mantoso/terraform-null-label/releases).

### Simple Example

```hcl-terraform
module mantoso_prod_bastion_label {
  source     = "git::https://github.com/mantoso/terraform-null-label.git?ref=master"
  namespace  = "mantoso"
  stage      = "prod"
  name       = "bastion"
  attributes = ["public"]
  delimiter  = "-"

  tags = {
    "BusinessUnit" = "XYZ",
    "Snapshot"     = "true"
  }
}
```

This will create an `id` with the value of `mantoso-prod-bastion-public` because when generating `id`, the default order is `namespace`, `account`, `stage`,  `name`, `attributes`. To override the order use the `label_order` variable. For an example, see [Advanced Example 3](#advanced-example-3)).

Now reference the label when creating an instance:

```hcl-terraform
resource aws_instance mantoso_prod_bastion_public {
  ami           = "ami-0022c769"
  instance_type = "t1.micro"
  tags          = module.mantoso_prod_bastion_label.tags
}
```

Or define a security group:

```hcl-terraform
resource "aws_security_group" "mantoso_prod_bastion_public" {
  vpc_id = var.vpc_id
  name   = module.mantoso_prod_bastion_label.id
  tags   = module.mantoso_prod_bastion_label.tags
  mantosoress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
```

### Advanced Example

Here is a more advanced example with two instances using two different labels. Note how efficiently the tags are defined for both the instance and the security group.

```hcl-terraform
module mantoso_prod_bastion_abc_label {
  source     = "git::https://github.com/mantoso/terraform-null-label.git?ref=master"
  namespace  = "mantoso"
  stage      = "prod"
  name       = "bastion"
  attributes = ["abc"]
  delimiter  = "-"

  tags = {
    "BusinessUnit" = "XYZ",
    "Snapshot"     = "true"
  }
}

resource aws_security_group mantoso_prod_bastion_abc {
  name = module.mantoso_prod_bastion_abc_label.id
  tags = module.mantoso_prod_bastion_abc_label.tags
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource aws_instance mantoso_prod_bastion_abc {
   ami                    = "ami-0022c769"
   instance_type          = "t1.micro"
   tags                   = module.mantoso_prod_bastion_abc_label.tags
   vpc_security_group_ids = [aws_security_group.mantoso_prod_bastion_abc.id]
}

module mantoso_prod_bastion_xyz_label {
  source     = "git::https://github.com/mantoso/terraform-null-label.git?ref=master"
  namespace  = "mantoso"
  stage      = "prod"
  name       = "bastion"
  attributes = ["xyz"]
  delimiter  = "-"

  tags = {
    "BusinessUnit" = "XYZ",
    "Snapshot"     = "true"
  }
}

resource aws_security_group mantoso_prod_bastion_xyz {
  name = module.mantoso_prod_bastion_xyz_label.id
  tags = module.mantoso_prod_bastion_xyz_label.tags
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource aws_instance mantoso_prod_bastion_xyz {
   ami                    = "ami-0022c769"
   instance_type          = "t1.micro"
   tags                   = module.mantoso_prod_bastion_xyz_label.tags
   vpc_security_group_ids = [aws_security_group.mantoso_prod_bastion_xyz.id]
}
```

### Advanced Example 2

Here another advanced example with an auto scaling group that has a different tagging schema than other resources and requires its tags to be in this format, which this module can generate:

```hcl-terraform
tags = [
    {
        key = Name,
        propagate_at_launch = 1,
        value = namespace-stage-name
    },
    {
        key = Namespace,
        propagate_at_launch = 1,
        value = namespace
    },
    {
        key = Stage,
        propagate_at_launch = 1,
        value = stage
    }
]
```

Auto scaling group using propagating tagging below. For a full example see: [autoscalinggroup](examples/autoscalinggroup/main.tf))

```hcl-terraform
module label {
  source    = "../../"
  namespace = "cp"
  stage     = "prod"
  name      = "app"

  tags = {
    BusinessUnit = "Finance"
    ManagedBy    = "Terraform"
  }

  additional_tag_map = {
    propagate_at_launch = "true"
  }
}

resource aws_launch_template default {
  # terraform-null-label example used here: Set template name prefix
  name_prefix                           = "${module.label.id}-"
  image_id                              = data.aws_ami.amazon_linux.id
  instance_type                         = "t2.micro"
  instance_initiated_shutdown_behavior  = "terminate"

  vpc_security_group_ids = [data.aws_security_group.default.id]

  monitoring {
    enabled = false
  }

  # terraform-null-label example used here: Set tags on volumes
  tag_specifications {
    resource_type = "volume"
    tags = module.label.tags
  }
}

resource aws_autoscaling_group default {
  # terraform-null-label example used here: Set ASG name prefix
  name_prefix         = "${module.label.id}-"
  vpc_zone_identifier = data.aws_subnet_ids.all.ids
  max_size            = "1"
  min_size            = "1"
  desired_capacity    = "1"

  launch_template = {
    id      = aws_launch_template.default.id
    version = "$$Latest"
  }

  # terraform-null-label example used here: Set tags on ASG and EC2 Servers
  tags                                  = module.label.tags_as_list_of_maps
}
```

### Advanced Example 3

In this advanced example you can see how you can pass the `context` output of one label module to the next label_module, allowing you to create one label that has the base set of values, and then creating every extra label as a derivative of that. [Complete example](./examples/complete)

```hcl-terraform
module "label1" {
  source      = "git::https://github.com/mantoso/terraform-null-label.git?ref=master"
  namespace   = "Mantoso"
  account     = "UAT"
  stage       = "build"
  name        = "Winston Churchill"
  attributes  = ["fire", "water", "earth", "air"]
  delimiter   = "-"

  label_order = ["name", "account", "stage", "attributes"]

  tags = {
    "City"    = "Dublin"
    "account" = "Private"
  }
}

module "label2" {
  source    = "git::https://github.com/mantoso/terraform-null-label.git?ref=master"
  context   = module.label1.context
  name      = "Charlie"
  stage     = "test"
  delimiter = "+"

  tags = {
    "City"    = "London"
    "account" = "Public"
  }
}

module "label3" {
  source    = "git::https://github.com/mantoso/terraform-null-label.git?ref=master"
  name      = "Starfish"
  stage     = "release"
  context   = module.label1.context
  delimiter = "."

  tags = {
    "Eat"    = "Carrot"
    "Animal" = "Rabbit"
  }
}
```

This creates label outputs like this:

```hcl-terraform
label1 = {
  "attributes" = [
    "fire",
    "water",
    "earth",
    "air",
  ]
  "delimiter" = "-"
  "id"        = "winstonchurchhill-uat-build-fire-water-earth-air"
  "name"      = "winstonchurchhill"
  "namespace" = "mantoso"
  "stage"     = "build"
}
label1_context = {
  "additional_tag_map" = {}
  "attributes" = [
    "fire",
    "water",
    "earth",
    "air",
  ]
  "delimiter" = "-"
  "enabled" = true
  "account" = "uat"
  "label_order" = [
    "name",
    "account",
    "stage",
    "attributes",
  ]
  "name" = "winstonchurchhill"
  "namespace" = "mantoso"
  "rmantosoex_replace_chars" = "/[^a-zA-Z0-9-]/"
  "stage" = "build"
  "tags" = {
    "Attributes" = "fire-water-earth-air"
    "City" = "Dublin"
    "account" = "Private"
    "Name" = "winstonchurchhill"
    "Namespace" = "mantoso"
    "Stage" = "build"
  }
}

label1_tags = {
  "Attributes" = "fire-water-earth-air"
  "City" = "Dublin"
  "account" = "Private"
  "Name" = "winstonchurchhill"
  "Namespace" = "mantoso"
  "Stage" = "build"
}

label2 = {
  "attributes" = [
    "fire",
    "water",
    "earth",
    "air",
  ]
  "delimiter" = "+"
  "id" = "charlie+uat+test+firewaterearthair"
  "name" = "charlie"
  "namespace" = "mantoso"
  "stage" = "test"
}

label2_context = {
  "additional_tag_map" = {}
  "attributes" = [
    "fire",
    "water",
    "earth",
    "air",
  ]
  "delimiter" = "+"
  "enabled" = true
  "account" = "uat"
  "label_order" = [
    "name",
    "account",
    "stage",
    "attributes",
  ]
  "name" = "charlie"
  "namespace" = "mantoso"
  "rmantosoex_replace_chars" = "/[^a-zA-Z0-9-]/"
  "stage" = "test"
  "tags" = {
    "Attributes" = "firewaterearthair"
    "City" = "London"
    "account" = "Public"
    "Name" = "charlie"
    "Namespace" = "mantoso"
    "Stage" = "test"
  }
}

label2_tags = {
  "Attributes" = "firewaterearthair"
  "City" = "London"
  "account" = "Public"
  "Name" = "charlie"
  "Namespace" = "mantoso"
  "Stage" = "test"
}

label3 = {
  "attributes" = [
    "fire",
    "water",
    "earth",
    "air",
  ]
  "delimiter" = "."
  "id" = "starfish.uat.release.firewaterearthair"
  "name" = "starfish"
  "namespace" = "mantoso"
  "stage" = "release"
}
label3_context = {
  "additional_tag_map" = {}
  "attributes" = [
    "fire",
    "water",
    "earth",
    "air",
  ]
  "delimiter" = "."
  "enabled" = true
  "account" = "uat"
  "label_order" = [
    "name",
    "account",
    "stage",
    "attributes",
  ]
  "name" = "starfish"
  "namespace" = "mantoso"
  "rmantosoex_replace_chars" = "/[^a-zA-Z0-9-]/"
  "stage" = "release"
  "tags" = {
    "Animal" = "Rabbit"
    "Attributes" = "firewaterearthair"
    "City" = "Dublin"
    "Eat" = "Carrot"
    "account" = "uat"
    "Name" = "starfish"
    "Namespace" = "mantoso"
    "Stage" = "release"
  }
}

label3_tags = {
  "Animal" = "Rabbit"
  "Attributes" = "firewaterearthair"
  "City" = "Dublin"
  "Eat" = "Carrot"
  "account" = "uat"
  "Name" = "starfish"
  "Namespace" = "mantoso"
  "Stage" = "release"
}
```

## Commercial Support

Work directly with our team of DevOps experts via email, slack, and video conferencing. 

We provide [commercial support][commercial_support] for all of our [Open Source][open source] projects. As a customer, you have access to our team of subject matter experts at a fraction of the cost of a full-time cloud engineer. 

- **Questions** We'll use a Shared Slack channel between your team and ours.
- **Troubleshooting** We'll help you triage why things aren't working.
- **Code Reviews** We'll review your Pull Requests and provide constructive feedback.
- **Bug Fixes** We'll rapidly work to fix any bugs in our projects.
- **Build Custom Terraform Modules** We will [develop custom modules][module development] to provision your infrastructure.
- **Cloud Architecture** We'll assist with your cloud strategy, best practices and design.
- **Implementation** We'll provide hands-on support to implement our reference architectures.

[![E-Mail](https://img.shields.io/badge/email-hello@mantoso.com-blue.svg)][email]

[commercial_support]: https://mantoso.com/commercial-support
[open source]: https://github.com/mantoso
[email]: mailto:hello@mantoso.com
[module development]: https://mantoso.com/module-development
