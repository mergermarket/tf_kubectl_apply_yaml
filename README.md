# tf_kubectl_apply_yaml
Apply yaml files to EKS using kubectl

This module will apply a yaml file to the EKS control plane using client AWS credentials for authentication

## Module Input Variables

- `filename` - (string) - **REQUIRED** - The name yaml file to apply.

## Usage

```hcl
module "roles" {
  source = "./modules/kubectl_apply_yaml"
  filename = "./yaml_files/role.yaml"
}
```

