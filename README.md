GitOps Mini Camp 2024 - More Than Certified 

<details>
  <summary>Table of Contents</summary>

- [Introduction](#introduction)
- [Similarities between GitHub Actions and Jenkins](#similarities-between-github-actions-and-jenkins)
- [Key Differences](#key-differences)
- [GitHub Actions Documentation](#github-actions-documentation)
- [GitHub Codespace Setup and Terraform Installation](#github-codespace-setup-and-terraform-installation)
- [Configuring OIDC (OpenID Connect)](#configuring-oidc-openid-connect)
  - [CLI CloudFormation Deployment](#cli-cloudformation-deployment)
  - [Manual Deployment](#manual-deployment)
- [Terraform State File AWS CloudFormation Stack](#terraform-state-file-aws-cloudformation-stack)
- [Setting Up GitHub Actions Workflows](#setting-up-github-actions-workflows)
- [Handling Terraform Security with TFLint and tfsec](#handling-terraform-security-with-tflint-and-tfsec)
  - [TFLint](#tflint)
  - [TFSec](#tfsec) - [Terraform Code Formatting and Validation](#terraform-code-formatting-and-validation)
- [Terraform Code Formatting and Validation](#terraform-code-formatting-and-validation)
  - [Terraform fmt](#terraform-fmt)
  - [Terraform validate](#terraform-validate)
- [Infrastructure Cost Estimation with Infracost](#infrastructure-cost-estimation-with-infracost)
- [Setting Up GitHub Actions Workflows for Terraform with OPA and Rego Policy Compliance](#setting-up-github-actions-workflows-for-terraform-with-opa-and-rego-policy-compliance)
  - [Detailed Steps for OPA and Rego Policy Compliance](#detailed-steps-for-opa-and-rego-policy-compliance)
    - [Step 1: Prepare Terraform Configurations for OPA Compliance](#step-1-prepare-terraform-configurations-for-opa-compliance)
    - [Step 2: Validate and Refine Policies in OPA Playground](#step-2-validate-and-refine-policies-in-opa-playground)
    - [Step 3: Define and Enforce Rego Policies in GitHub Actions](#step-3-define-and-enforce-rego-policies-in-github-actions)
    - [Step 4: Integrate Policy Check into GitHub Actions Workflow](#step-4-integrate-policy-check-into-github-actions-workflow)
- [Grafana Overview](#grafana-overview)
  - [Initial Setup and Bootstrap for EC2](#initial-setup-and-bootstrap-for-ec2)
  - [Accessing Grafana](#accessing-grafana)
  - [Default Login Credentials](#default-login-credentials)
  - [Best Practices for Grafana Access and Security](#best-practices-for-grafana-access-and-security)
- [Grafana Health Checks and Workaround](#grafana-health-checks-and-workaround)
- [Further Reading](#further-reading)

</details>


<details>
  <summary>Project Architecture</summary>
  <p align="center">
    <img src="images/GitOps%20Architecture%20.png" alt="GitOps Architecture">
  </p>
</details>


# Introduction
I am utilising GitHub Actions to automate the deployment of features into my AWS environment. By leveraging continuous integration and deployment (CI/CD) pipelines, I ensure that my code is tested, built, and deployed efficiently and consistently. Additionally, I implement semantic versioning to manage and track software changes, allowing for clear version updates that follow a predictable and standardised format. This approach ensures that each new feature, bug fix, or breaking change is systematically reflected in the versioning. This automation and versioning strategy simplifies my development process, allowing me to focus on delivering high-quality features with minimal manual intervention whilst maintaining full control over the release cycle.

You can find detailed information on semantic versioning from the official documentation at [Semantic Versioning](https://semver.org/)​, often abbreviated as SemVer, is a versioning system designed to clearly communicate the nature of changes in a software release.

In essence:

- Major version (X) changes introduce incompatible changes to the API.
- Minor version (Y) increments when new, backward-compatible features are added.
- Patch version (Z) increases when backward-compatible bug fixes are made.

For example, a version number like 1.2.3 means it's the first major version, with two sets of new features (minor updates) and three sets of bug fixes (patch updates) since version 1.0.0​

## Similarities between GitHub Actions and Jenkins:
CI/CD Automation: Both GitHub Actions and Jenkins are widely used for automating Continuous Integration and Continuous Deployment (CI/CD) workflows. They help ensure that code is automatically tested, built, and deployed.

Event-driven Workflows: Both platforms allow workflows to be triggered by events, such as code commits or pull requests.

Customisable Pipelines: Jenkins uses "pipelines" defined in Jenkinsfiles, while GitHub Actions uses YAML configuration files to define "workflows." Both systems allow customisation of tasks and sequences for different stages in the development cycle.

Community Plugins/Marketplace: Jenkins has an extensive library of plugins to extend functionality, while GitHub Actions has a marketplace full of reusable actions shared by the community.

**Key Differences:**
1.**Hosting and Setup:**
GitHub Actions is tightly integrated into GitHub, making it easy to use for repositories hosted on GitHub. It's cloud-based, so there's no need for infrastructure management.
Jenkins is typically self-hosted, requiring you to manage the infrastructure, updates, and security. It can be more complex to set up and maintain but offers greater flexibility for custom environments.

2.**Ease of Use:** GitHub Actions is known for its simplicity, especially for projects already on GitHub. It's easier for beginners and integrates seamlessly with GitHub repositories. Jenkins offers more complex configurations and flexibility for large-scale enterprise environments, but the learning curve can be steeper.

3.**Ecosystem Integration:** GitHub Actions is directly integrated with the GitHub ecosystem, which simplifies workflows like version control, collaboration, and issue tracking. Jenkins can integrate with many different tools and services, making it more versatile for projects hosted outside of GitHub.

4.**Scalability and Customization:** Jenkins is highly customisable and scalable, suitable for more complex or enterprise-grade CI/CD pipelines that need fine control over the environment. GitHub Actions is scalable for most use cases, but it may not offer the same degree of flexibility for complex, multi-platform environments as Jenkins.

**Conclusion:** You can say GitHub Actions is similar to Jenkins in its purpose (CI/CD automation), but GitHub Actions is more streamlined and integrated into GitHub, whereas Jenkins offers more control and flexibility, especially in self-hosted environments. Depending on the complexity of your project and infrastructure needs, one might be more suitable than the other.

## GitHub Actions Documentation:
1.**Official GitHub Actions Documentation:**
GitHub provides thorough documentation on how to set up, configure, and use GitHub Actions. It covers topics from basic workflows to more advanced use cases.
[GitHub Actions Documentation](https://docs.github.com/en/actions)

2.**GitHub Marketplace for Actions:**
You can explore pre-built actions to use in your workflows from the GitHub Marketplace. This can help save time and effort by using community-contributed actions.
[GitHub Actions Marketplace](https://github.com/marketplace?type=actions)

3.**GitHub Learning Lab:**
GitHub also offers interactive tutorials on how to use GitHub Actions, allowing you to learn through hands-on examples.
[GitHub Learning Lab - GitHub Actions](https://lab.github.com/githubtraining/github-actions:-hello-world)


## GitHub Codespace setup Terraform installation (setting up the environment)

To install Terraform in GitHub Codespaces, which runs on Linux ubuntu by default, you'll need to follow the Linux-specific installation instructions.

1. Ensure that your system is up to date and you have installed the gnupg, software-properties-common, and curl packages installed. You will use these packages to verify HashiCorp's GPG signature and install HashiCorp's Debian package repository.
```bash
sudo apt-get update && sudo apt-get install -y gnupg software-properties-common
```

2. Install the HashiCorp GPG key.
```bash 
wget -O- https://apt.releases.hashicorp.com/gpg | \
gpg --dearmor | \
sudo tee /usr/share/keyrings/hashicorp-archive-keyring.gpg > /dev/null
```
3. Verify the key's fingerprint.
```bash 
gpg --no-default-keyring \
--keyring /usr/share/keyrings/hashicorp-archive-keyring.gpg \
--fingerprint
```
4. Add the official HashiCorp repository to your system.
```bash
echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] \
https://apt.releases.hashicorp.com $(lsb_release -cs) main" | \
sudo tee /etc/apt/sources.list.d/hashicorp.list
```
Download the package information from HashiCorp.
```bash 
sudo apt update
```
5. Update the required packages.
```bash
sudo apt-get install -y terraform
```
6. Install Terraform from the new repository.
```bash 
sudo apt-get install terraform
```

8. Veryify installed by running. 
```bash
 terraform -version 
```
**The return should look something like this:**
Terraform v1.9.8
on linux_amd64

## Git is installed in Codespace by default, but you can check by running 

```bash 
git --version 
```
**The return should be something like this:** 
git version 2.46.2

## Configuring the OIDC (OpenID Connect)

An OIDC (OpenID Connect) provider allows AWS to establish a trust relationship with GitHub for roles to assume permissions via OIDC. You can have only one OIDC provider per AWS account for a specific URL (e.g., https://token.actions.githubusercontent.com), but you can associate multiple roles with that provider. If you do not delete an existing OIDC provider, deploying a new stack with the same provider can result in a conflict error.



For more details,[AWS OIDC Documentation] https://docs.aws.amazon.com/IAM/latest/UserGuide/id_roles_providers_create_oidc.html.

```yaml
 ManagedPolicyArns:
        - 'arn:aws:iam::177469626005:policy/gitops-minicamp-2024' # Make sure this is the policy Arn and not the Role Arn.
```
### Cli Cloud Formation Deployment

You can deploy the stack via the cli, but I am going to do it manually via the console. 

```bash
aws cloudformation deploy \
  --template-file <your-template-file.yaml> \
  --stack-name <your-stack-name> \
  --parameter-overrides Key1=Value1 Key2=Value2 \
  --capabilities CAPABILITY_NAMED_IAM
  ```
Replace <your-template-file.yaml> with the path to your CloudFormation template.
Replace <your-stack-name> with a name for your stack.
Add any required parameters and capabilities.

### Manual deployment

- Navigate to Cloud Formation, 
- Build from infrastructure composer 
- Create from infrastructure composer 
- Then chose template and paste in all code text

For more details, visit [AWS documentation](https://docs.aws.amazon.com/cli/latest/reference/cloudformation/deploy.html)

## Terraform State File AWS CloudFormation Stack

Save the template as state-management.yaml or I saved it under cfn as backend-resource.yaml.

Run the following command to deploy it:

```bash
aws cloudformation deploy \
  --template-file state-management.yaml \
  --stack-name terraform-state-management \
  --capabilities CAPABILITY_NAMED_IAM
  ```
Configure Terraform to Use Remote State: In your Terraform configuration, add the following backend configuration:

```bash
terraform {
  backend "s3" {
    bucket         = "gitops-minicamp-terraform-state"
    key            = "terraform.tfstate"
    region         = "us-west-2" # update to your region
    dynamodb_table = "terraform-state-lock"
    encrypt        = true
  }
}
```
## How to set up GitHub Actions specifically for your project. Here’s an example of a simple workflow definition
file name = .github/workflows/ci.yml

```yml
name: CI Pipeline
on:
  push:
    branches:
      - main
  pull_request:
    branches:
      - main

jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - name: Checkout Code
        uses: actions/checkout@v4 # ensure the latest version 

      - name: Set up Node.js
        uses: actions/setup-node@v8
        with:
          node-version: '16'

      - name: Install Dependencies
        run: npm install

      - name: Run Tests
        run: npm test
```

**Official Jenkins Documentation:**
[Jenkins Documentation](https://www.jenkins.io/doc/)

## Handling Terraform Security with TFLint and tfsec
To improve security and configuration best practices, integrate TFLint and tfsec within your workflow.

In Terraform projects, security and configuration scanning play a critical role in ensuring that infrastructure adheres to best practices, security guidelines, and organizational policies. This repository integrates TFLint and tfsec within GitHub Actions to automate these checks, flagging potential issues early in the deployment pipeline.

TFLint: Configuration Linting
Purpose: TFLint is a linter for Terraform that checks for issues such as misconfigurations, improper resource types, and potential errors in syntax or structure. It’s designed to catch configuration issues before they lead to deployment failures.

Usage: TFLint runs automatically within GitHub Actions, providing feedback directly on any detected misconfigurations.

TFLint:
Runs as a GitHub Action to catch misconfigurations and linting errors in your Terraform files.

Example Action:
```yaml
name: TFLint Workflow

on:
  pull_request:
    branches:
      - main
  push:
    branches:
      - main

jobs:
  lint:
    runs-on: ubuntu-latest
    steps:
      - name: Checkout Code
        uses: actions/checkout@v4

      - name: Set up TFLint
        uses: terraform-linters/setup-tflint@v4
        with:
          version: v0.52.0

      - name: Run TFLint
        run: tflint --format compact
int --format compact
```
TFSec: Introduction
tfsec is a static analysis tool designed to help identify potential security risks in Terraform configurations. By scanning .tf files, tfsec detects possible misconfigurations and security issues based on best practices and security standards, making it an essential tool for maintaining secure infrastructure.

With tfsec, you can proactively address vulnerabilities before deployment, including checks for:

Misconfigured security groups
Insufficient encryption settings
Inadequate IAM permissions
Publicly accessible resources that should be private
By integrating tfsec into your workflow, you can automatically scan Terraform code to ensure compliance with security policies and industry best practices, such as the CIS (Center for Internet Security) benchmarks and the AWS Well-Architected Framework.

exampl Action:
```yaml
name: TFSec Workflow

on:
  pull_request:
    branches:
      - main
  push:
    branches:
      - main

jobs:
  security_check:
    runs-on: ubuntu-latest
    steps:
      - name: Checkout Code
        uses: actions/checkout@v4

      - name: Install TFSec
        run: |
          curl -s https://raw.githubusercontent.com/aquasecurity/tfsec/master/scripts/install.sh | bash

      - name: Run TFSec
        run: tfsec --format compact
```

Example Use Cases for TFSec
Publicly Accessible Resources: tfsec can detect if a resource is exposed to the public (e.g., a security group allowing access from 0.0.0.0/0).
Lack of Encryption: Identifies unencrypted resources, such as unencrypted S3 buckets or unencrypted root volumes for EC2 instances.
Missing IAM Role Constraints: Flags resources with overly permissive IAM roles or policies, encouraging the principle of least privilege.
Ignoring Specific tfsec Warnings
In some cases, such as for a development environment or proof-of-concept deployment, it may be necessary to override certain security warnings. tfsec provides an ignore feature to selectively bypass specific warnings.

Example
For instance, to allow a public IP for a subnet in development, add an ignore comment to the relevant Terraform code:

```hcl
resource "aws_subnet" "example_subnet" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.0.0/24"
  # tfsec:ignore:aws-ec2-no-public-ip-subnet
  map_public_ip_on_launch = true

  tags = {
    Name = "example-subnet"
  }
}
```
This ignore comment tells tfsec to skip the aws-ec2-no-public-ip-subnet rule for this specific configuration, allowing for flexibility while still maintaining security checks on the rest of your infrastructure.

Integrating tfsec into your CI/CD pipeline helps maintain a secure codebase, and its ignore functionality provides a balance between enforcing policies and allowing necessary exceptions.

## Terraform Code Formatting and Validation
Terraform provides tools to ensure consistent formatting and validate configuration files for reliability. Here’s a breakdown of both the manual and automated processes:

terraform fmt: Formats all Terraform configuration files to a standard style.
terraform validate: Validates the configuration files for syntax and configuration issues.
1. Running terraform fmt Manually
To run terraform fmt on all Terraform files in the ./terraform directory, use:

```bash
terraform fmt ./terraform
```
This command formats .tf files only within the specified ./terraform directory. You can also specify individual files if needed:

```bash
terraform fmt ./terraform/main.tf
terraform fmt ./terraform/providers.tf
```
2. Setting up Pre-Commit Hooks for terraform fmt and terraform validate
Using pre-commit hooks, you can automate these checks before every commit.

Install pre-commit:

```bash
pip install pre-commit
```
Add a .pre-commit-config.yaml file with configuration for Terraform hooks:

```yaml
Copy code
repos:
  - repo: https://github.com/antonbabenko/pre-commit-terraform
    rev: v1.96.2  # Update to latest stable version
    hooks:
      - id: terraform_fmt
        args: ["./terraform"]
      - id: terraform_validate
        args: ["./terraform"]
```
Install the pre-commit hooks:

```bash
pre-commit install
```
This configuration ensures that only files in ./terraform are checked for formatting and validated.
[The pre commit terraform repository](https://github.com/antonbabenko/pre-commit-terraform)

3. Integrating terraform fmt and terraform validate in GitHub Actions
To add these checks to a GitHub Actions workflow, specify the directory containing Terraform files. This setup validates formatting and configuration for every push and pull request:

```yaml
name: 'Terraform Formatting and Validation'

on:
  pull_request:
    branches:
      - main
  push:
    branches:
      - main

jobs:
  terraform:
    runs-on: ubuntu-latest
    steps:
      - name: Checkout Code
        uses: actions/checkout@v4

      - name: Set up Terraform
        uses: hashicorp/setup-terraform@v3
        with:
          terraform_version: 1.9.8

      - name: Terraform Format Check
        run: terraform fmt -check ./terraform

      - name: Terraform Validate
        run: terraform validate ./terraform
```
By specifying ./terraform, you ensure the terraform fmt and terraform validate commands target the correct directory. This setup maintains clean, validated infrastructure code across the repository.

## Infrastructure Cost Estimation with Infracost

Infracost estimates infrastructure costs directly from Terraform configurations, providing insights into expected costs before deployment.

Setup and Integration:

```yaml
- name: Run Infracost
  run: |
    infracost breakdown --path /path/to/terraform --format json
```

Tagging Requirements: If Infracost flags missing tags and you struggling to address the issue, add a default tag to the AWS provider block configuration:

```hcl

  default_tags {
    tags = {
      Service     = "GitOps Minicamp 2024"  # Indicates the name of this project or application
      Environment = "Dev" # Indicates the deployment environment (e.g., Development) Infracost only recognises Dev, Stage or Prod shorthand
    }
  }
}
```

## Setting Up GitHub Actions Workflows for Terraform with OPA and Rego Policy Compliance
With your environment ready, you can configure GitHub Actions workflows to automate Terraform operations, enforce compliance policies with OPA/Rego, and estimate infrastructure costs. This setup uses JSON exports of Terraform plans for OPA validation, a structured policies folder, and Rego policies to ensure compliance before deployment.

Workflow Structure
Terraform Plan:
This step generates a Terraform plan in JSON format, which is then used as input for policy checks.

```yaml
- name: Terraform Plan
  id: plan
  run: |
    terraform plan -out=plan.tfplan
    terraform show -json plan.tfplan > /tmp/plan.json
OPA Compliance Check with Rego:
Place all Rego policies inside a policies folder to maintain organization and specify compliance checks in your workflow. The following step runs the compliance check by calling the instance-policy.rego file from the policies directory.

```yaml
- name: Run OPA Compliance Check
  run: |
    opaout=$(opa eval --data /workspaces/gitops-minicamp-2024/policies/instance-policy.rego --input /tmp/plan.json "data.terraform.deny" | jq -r '.result[].expressions[].value[]' || echo "null")
    [ "$opaout" = "null" ] && exit 0 || echo "$opaout" && gh pr comment --body "### $opaout" --number "${{ github.event.pull_request.number }}" && exit 1
```
Note: If any policy is violated, a comment will be added to the PR with the specific issue, and the action will exit with a non-zero status to prevent deployment.


Terraform Apply:
Deploys the changes to AWS only if the OPA compliance check passes.

```yaml
- name: Terraform Apply
  run: terraform apply "plan.tfplan"
  ```

Terraform Destroy (Optional):
Removes infrastructure when needed.

```yaml
- name: Terraform Destroy
  run: terraform destroy -auto-approve
```

### Detailed Steps for OPA and Rego Policy Compliance

- Step 1: Prepare Terraform Configurations for OPA Compliance
Issue: To validate Terraform configurations with OPA, it’s essential to first export the Terraform plans as JSON.

Solution: Export the Terraform plan as a JSON file. This JSON output will then be used in the OPA Playground for testing and further adjustments before incorporating policies into GitHub Actions.

Export Command:

```bash
terraform show -json tfplan.binary > tfplan.json
```

- Step 2: Validate and Refine Policies in OPA Playground
Upload JSON to OPA Playground: Use the exported tfplan.json in the OPA Playground to validate and refine your Rego policies.
Test Policy Logic: Use the playground’s output to identify policy violations and ensure the logic works as expected.
Refine Policies: Adjust and clean up the policies as needed. Once they’re verified to work in the playground, they are ready for implementation in your CI/CD pipeline.

- Step 3: Define and Enforce Rego Policies in GitHub Actions
After verifying the policy in the OPA Playground, you can integrate it into your GitHub Actions workflow to enforce policies on instance types or other requirements before deployment.

Define Rego Policy: Create policies in a dedicated policies folder within your project. Here’s an example instance-policy.rego that enforces approved instance types.
```rego
package terraform

allowed_instance_types := ["t2.small", "t3.nano"]

deny[msg] if {
  resource := input.resource_changes[_]
  resource.type == "aws_instance"
  instance_type := resource.change.after.instance_type
  not instance_type in allowed_instance_types
  msg := sprintf(
      "Instance type '%s' is not approved",
      [instance_type]
  )
}
```

- Step 4: Integrate Policy Check into GitHub Actions Workflow
Run OPA Evaluation: In your GitHub Actions workflow, use the opa eval command to run compliance checks based on your Rego policies. Place the following step in your workflow YAML file:
```yaml
- name: Run OPA Compliance Check
  run: |
    opaout=$(opa eval --data policies/instance-policy.rego --input /tmp/plan.json "data.terraform.deny" | jq -r '.result[].expressions[].value[]' || echo "null")
    [ "$opaout" = "null" ] && exit 0 || echo "$opaout" && gh pr comment --body "### $opaout" --
```

## Grafana Overview

Grafana is an open-source analytics and interactive visualization tool. It allows users to query, visualise, alert, and understand their metrics from various data sources, such as Prometheus, InfluxDB, MySQL, and AWS CloudWatch. Grafana's dynamic dashboards are especially useful for monitoring infrastructure and application performance over time, making it widely used in DevOps, data analysis, and system monitoring.

Initial Setup and Bootstrap for EC2
To deploy Grafana on an EC2 instance, you can use the following bootstrap script to set up Grafana on Amazon Linux 2 or a compatible Ubuntu distribution:

```bash
#!/bin/bash
# Update package lists and install dependencies
sudo apt-get update
sudo apt-get install -y software-properties-common

# Add Grafana’s official repository and install Grafana
wget -q -O - https://packages.grafana.com/gpg.key | sudo apt-key add -
sudo add-apt-repository "deb https://packages.grafana.com/oss/deb stable main"
sudo apt-get update
sudo apt-get install -y grafana

# Start and enable Grafana service
sudo systemctl start grafana-server
sudo systemctl enable grafana-server
```

This script performs the following:

Updates the package lists.
Adds Grafana's official repository to ensure you receive the latest stable version.
Installs Grafana, then starts and enables the Grafana server, so it starts automatically after a reboot.
Accessing Grafana
After the installation, Grafana will be accessible on port 3000. To access it, use one of the following options:

Locally: If you have SSH port forwarding enabled, access Grafana from your browser at localhost:3000.
Public IP: To access Grafana remotely, navigate to http://<public-IP>:3000, where <public-IP> is the public IP address of your EC2 instance.

Default Login Credentials
On first access, Grafana requires authentication:
-Username: admin
-Password: admin (Grafana will prompt you to set a new password on initial login for enhanced security).

Best Practices for Grafana Access and Security
Limit Public Access: To avoid exposing Grafana directly to the internet, consider using an SSH tunnel or restricting access via a VPN or private network.
Use Strong Authentication: Integrate Grafana with your organization's identity provider, if available, to enforce multi-factor authentication and streamline user management.
Enable HTTPS: Configure Grafana to serve over HTTPS to secure data transmission.
Regular Updates: Keep Grafana updated to benefit from the latest security patches and features.

### Grafana Health Checks and Workaround
Grafana can be accessed on port 3000, typically with the default login admin / admin. I encountered issues when using the API health endpoint, as it doesn’t always return a 200 OK. Instead, the following health check confirms accessibility:

Health Check Provisioner:

```bash
Copy code
provisioner "local-exec" {
  command = <<EOT
    bash -c '
      for ((i=1; i<=20; i++)); do
        response=$(curl -s -o /dev/null -w "%{http_code}" http://${self.public_ip}:3000/api/health)
        if [ "$response" -eq "200" ]; then
          echo "Grafana is accessible and healthy on port 3000."
          exit 0
        else
          echo "Attempt $i: Grafana health check failed, not accessible on port 3000 yet."
          sleep 20
        fi
      done
      echo "Grafana failed to start after 20 attempts"
      exit 1
    '
  EOT
}
```

**Further Reading**

- [GitHub Actions Documentation](https://docs.github.com/en/actions) - Official documentation for GitHub Actions.
- [Terraform Documentation](https://www.terraform.io/) - Terraform’s official documentation.
- [Terraform Providers](https://registry.terraform.io/browse/providers) - Browse available Terraform providers.
- [Infracost Documentation](https://www.infracost.io/docs/features/config_file/) - Infracost configuration and usage documentation.
- [Open Policy Agent Documentation](https://www.openpolicyagent.org/docs/latest/policy-language/) - OPA policy language reference.
- [Rego Playground](https://play.openpolicyagent.org/) - Try out Rego policies in an interactive playground.
- [Jenkins Documentation](https://www.jenkins.io/doc/) - Official Jenkins documentation.
