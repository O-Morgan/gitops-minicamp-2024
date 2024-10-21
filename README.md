# gitops-minicamp-2024
More Than Certified GitOps Mini Camp

## Table of Contents
- [Introduction](#introduction)
- [Similarities between GitHub Actions and Jenkins](#similarities-between-github-actions-and-jenkins)
  - [Key Differences](#key-differences)
- [GitHub Actions Documentation](#github-actions-documentation)
- [GitHub Codespace setup Terraform installation](#github-codespace-setup-terraform-install)
- [Configuring the OIDC (OpenID Connect)](#configuring-the-oidc-openid-connect)




# Introduction
I am utilising GitHub Actions to automate the deployment of features into my AWS environment. By leveraging continuous integration and deployment (CI/CD) pipelines, I ensure that my code is tested, built, and deployed efficiently and consistently. Additionally, I implement semantic versioning to manage and track software changes, allowing for clear version updates that follow a predictable and standardised format. This approach ensures that each new feature, bug fix, or breaking change is systematically reflected in the versioning. This automation and versioning strategy simplifies my development process, allowing me to focus on delivering high-quality features with minimal manual intervention whilst maintaining full control over the release cycle.

You can find detailed information on semantic versioning from the official documentation at [Semantic Versioning](https://semver.org/)​, often abbreviated as SemVer, is a versioning system designed to clearly communicate the nature of changes in a software release.

In essence:

- Major version (X) changes introduce incompatible changes to the API.
- Minor version (Y) increments when new, backward-compatible features are added.
- Patch version (Z) increases when backward-compatible bug fixes are made.

For example, a version number like 1.2.3 means it's the first major version, with two sets of new features (minor updates) and three sets of bug fixes (patch updates) since version 1.0.0​

### Similarities between GitHub Actions and Jenkins:
CI/CD Automation: Both GitHub Actions and Jenkins are widely used for automating Continuous Integration and Continuous Deployment (CI/CD) workflows. They help ensure that code is automatically tested, built, and deployed.

Event-driven Workflows: Both platforms allow workflows to be triggered by events, such as code commits or pull requests.

Customisable Pipelines: Jenkins uses "pipelines" defined in Jenkinsfiles, while GitHub Actions uses YAML configuration files to define "workflows." Both systems allow customisation of tasks and sequences for different stages in the development cycle.

Community Plugins/Marketplace: Jenkins has an extensive library of plugins to extend functionality, while GitHub Actions has a marketplace full of reusable actions shared by the community.

**Key Differences:**
1. **Hosting and Setup:**
GitHub Actions is tightly integrated into GitHub, making it easy to use for repositories hosted on GitHub. It's cloud-based, so there's no need for infrastructure management.
Jenkins is typically self-hosted, requiring you to manage the infrastructure, updates, and security. It can be more complex to set up and maintain but offers greater flexibility for custom environments.

2. **Ease of Use:** GitHub Actions is known for its simplicity, especially for projects already on GitHub. It's easier for beginners and integrates seamlessly with GitHub repositories. Jenkins offers more complex configurations and flexibility for large-scale enterprise environments, but the learning curve can be steeper.

3. **Ecosystem Integration:** GitHub Actions is directly integrated with the GitHub ecosystem, which simplifies workflows like version control, collaboration, and issue tracking. Jenkins can integrate with many different tools and services, making it more versatile for projects hosted outside of GitHub.

4. **Scalability and Customization:** Jenkins is highly customisable and scalable, suitable for more complex or enterprise-grade CI/CD pipelines that need fine control over the environment. GitHub Actions is scalable for most use cases, but it may not offer the same degree of flexibility for complex, multi-platform environments as Jenkins.

**Conclusion:** You can say GitHub Actions is similar to Jenkins in its purpose (CI/CD automation), but GitHub Actions is more streamlined and integrated into GitHub, whereas Jenkins offers more control and flexibility, especially in self-hosted environments. Depending on the complexity of your project and infrastructure needs, one might be more suitable than the other.

### GitHub Actions Documentation:
1. **Official GitHub Actions Documentation:**
GitHub provides thorough documentation on how to set up, configure, and use GitHub Actions. It covers topics from basic workflows to more advanced use cases.
[GitHub Actions Documentation](https://docs.github.com/en/actions)

2. **GitHub Marketplace for Actions:**
You can explore pre-built actions to use in your workflows from the GitHub Marketplace. This can help save time and effort by using community-contributed actions.
[GitHub Actions Marketplace](https://github.com/marketplace?type=actions)

3. **GitHub Learning Lab:**
GitHub also offers interactive tutorials on how to use GitHub Actions, allowing you to learn through hands-on examples.
[GitHub Learning Lab - GitHub Actions](https://lab.github.com/githubtraining/github-actions:-hello-world)


How to set up GitHub Actions specifically for your project. Here’s an example of a simple workflow definition
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
        uses: actions/checkout@v3 # ensure the latest version 

      - name: Set up Node.js
        uses: actions/setup-node@v3
        with:
          node-version: '16'

      - name: Install Dependencies
        run: npm install

      - name: Run Tests
        run: npm test
```

**Official Jenkins Documentation:**
[Jenkins Documentation](https://www.jenkins.io/doc/)

## GitHub Codespace setup Terraform installation

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

### Git is installed in Codespace by default, but you can check by running 

```bash 
git --version 
```
**The return should be something like this:** 
git version 2.46.2

# Configuring the OIDC (OpenID Connect)

An OIDC (OpenID Connect) provider allows AWS to establish a trust relationship with GitHub for roles to assume permissions via OIDC. You can have only one OIDC provider per AWS account for a specific URL (e.g., https://token.actions.githubusercontent.com), but you can associate multiple roles with that provider. If you do not delete an existing OIDC provider, deploying a new stack with the same provider can result in a conflict error.You can only have one OIDC providers within your account, so if you try to launch multiple it will throw you an error. However, you can use multiple roles and just not multiple OIDC Providers. 



For more details,[AWS OIDC Documentation] https://docs.aws.amazon.com/IAM/latest/UserGuide/id_roles_providers_create_oidc.html.

```yaml
 ManagedPolicyArns:
        - 'arn:aws:iam::182399680009:policy/gitops-minicamp-2024' # Make sure this is the policy Arn and not the Role Arn.
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

For more details, visit [AWS documentation]https://docs.aws.amazon.com/cli/latest/reference/cloudformation/deploy.html