# Documentation
This repository contains the explanation about an DevOps process, created using the CI/CD stack provided by Amazon Web Services. This Infrastructure as Code was made using Terraform.

#### Table of contents
1. [Diagram](#1-diagram)
2. [Requirements](#2-requirements)
3. [Techonoly Stack](#3-technology-stack)
4. [Project Structure](#4-project-structure)
5. [Variables](#5-variables)
6. [Terraform commands](#6-terraform-commands)
7. [References](#7-references)

---

## 1. Diagram
![Pipeline diagram](/images/pipeline-diagram.png)
This CI/CD process was made to release new changes to a production environment, and contains a basic process to store a git repository, build the project and release new changes.

1. First, the process begin when a developer execute `git push` command in them local environment.
2. Second, all changes are store in a private git respository managed by AWS CodeCommit.
3. Third, a cloudwatch event is configured to detect when in the private repository a new commit was performed. After detect the new commit, Cloudwatch event triggers the next transition to CodeBuild.
    - All repository files are sent, the most important are `buildspec.yml` and `appspec.yml`.
4. AWS CodeBuild input receives all files, using `buildspec.yml` configurations, CodeBuild performs all tasks specified and install dependencies, libraries and artifacts needed to execute the application.
5. CodeBuild artifact results are stored in a S3 Bucket that is encrypted using a KMS key.
6. CodeDeploy input is feeded with the CodeBuild output (stored in a S3 bucket) and uses `appspec.yml` to perform deployment process to an EC2 instance, installing and configuring the EC2 instance with all dependencies and server configurations.
---
### 2. Requirements
Before use this script, user must achieve this requirements:
1. A CodeCommit Private Repository created.
2. EC2 instance deployed
3. A ec2 instance profile with S3 full permissions, SSM full access, and KMS permissions 
4. Codeploy Agent installed in the ec2 instance, for Codedeploy has communication with the instance and execute the deployment process.
---
### 3. Technology stack
`buildspec.yml` and `appspec.yml` are constructed to support the following technologies:
1. Node.js 
2. Nodemon
3. NPM
4. Nginx
---
### 4. Project Structure

```sh
.
├── ci-cd-pipeline
│   ├── 01-kms-keys
│   │   ├── main.tf
│   │   ├── outputs.tf
│   │   └── variables.tf
│   ├── 02-iam-permissions
│   │   ├── data.tf
│   │   ├── main.tf
│   │   ├── output.tf
│   │   └── variables.tf
│   ├── 03-s3-bucket
│   │   ├── main.tf
│   │   ├── output.tf
│   │   └── variables.tf
│   ├── 04-code-build
│   │   ├── main.tf
│   │   └── variables.tf
│   ├── 05-code-deploy
│   │   ├── main.tf
│   │   ├── outputs.tf
│   │   └── variables.tf
│   └── 06-codepipeline
│       ├── main.tf
│       └── variables.tf
├── codepipeline-specs
│   ├── appspec.yml
│   └── buildspec.yml
├── envs
│   ├── backend-dev.hcl
│   ├── backend-env.hcl.template
│   ├── dev.tfvars
│   └── dev.tfvars.template
├── images
│   └── pipeline-diagram.png
├── main.tf
├── README.md
├── variables.tf
└── version.tf

```
- `ci-cd-pipeline` contains all neccesary modules to contruct the pipeline
  - `01-kms-keys` is a module to create a Symetric KMS key to encrypt all artifacts and resources generated by the pipeline. Artifacts will be store in a S3 Bucket and the KMS key will be attached it.
  - `02-iam-permissions` is a module to create all policies and roles needed to grant access to all codepipeline components.
  - `03-s3-bucket` is a module to create the S3 bucket where all artifacts and output will be stored by each codepipeline stage.
  - `04-code-build` is a module to create a code build project, this service installed all dependencies and build the project.
  - `05-code-deploy` is a module to create a code deploy project, this service connect the pipeline with the infraestructure to set up the servers and run the application.
  - `06-codepipeline` is a module to create the pipeline and integrate all aws ci/cd components in stages (codecommit, codebuild, codedeploy), and orchestrate releases. 
- `codepipeline-specs` contains documents specifications with commands and configurations to run in each stage, `appspec.yml` used to deploy stage and `buildspec.yml` to run build in build stage.
- `envs` folder contains files to configure the infraestructure
  - `backend-dev.hcl` has the configurations to set up the s3 bucket where the terraform artifacts, states and resources are stored.
  - `dev.tfvars` has the variable values to set up the infrastructure
- `main.tf` contains the implementation of each module and the variables used to configure each module.
- `variables.tf` contains the variables project to set up project configurations 
- `version.tf` contains provider configuration and credentials to access to the console.

### 5. Variables 

```js
aws_region                   = "aws region where infrastructure will be deployed"
aws_profile                  = "aws profile with access keys to connect to the account"

s3_bucket_name_pipeline             = "s3 bucket name for the codepipeline"
kms_key_name                        = "kms key name"
codedeploy_name                     = "Codedeploy project name"
codepipeline_name                   = "Codepipeline project name"
codebuild_name                      = "Codebuild project name"
build_project_source                = "CODEPIPELINE" 
builder_compute_type                = "compute type to run building process"
builder_image                       = "image with libraries and dependencies to configure the building server"
builder_type                        = "OS to set up the environment building" 
codecommit_repo_name                = "Codecommit repository name"
codecommit_repo_branch              = "Codecommit repository branch"
pipeline_stage_build_name           = "Stage name for build"
pipeline_stage_deploy_name          = "Stage name for deploy" 
artifact_identifier                 = "Artifact identifier" //name to use on buildspec
execution_mode                      = "Execution mode for codepipeline"
version_pipeline                    = "Codepipeline version"

environment        = "Describe the kind of environment in that the resources will be used (dev|uat|prod)"
created_by         = "Person who created the resource"
application        = "The service or application of which the resource is a component"
cost_center        = "Useful for billing center (Human Resources | IT department)"
contact            = "email address for the team or individual"
maintenance_window = "Useful for defining a window of time that resource is allows to not be available in case of parching, updates, or maintance"
deletion_date      = "Useful for development or sandbox environments so that you know when it may be safe to delete a resource"
```

### 6. Terraform commands
```bash
# prepare dependencies and reference to remote backend
terraform init -backend-config=envs/backend-dev.hcl
# reconfigure dependencies
terraform init -backend-config=envs/backend-dev.hcl -reconfigure
# prepare resources to deploy 
terraform plan -var-file=envs/dev.tfvars
# deploy resources to aws
terraform apply -var-file=envs/dev.tfvars
# destroy resources
terraform destroy -var-file=envs/uat.tfvars
# destroy resources that belongs a specific module
terraform destroy -var-file=envs/uat.tfvars -target=module.vpc
```


#### 7. References

[Create Codepipeline Service Role](https://docs.aws.amazon.com/codepipeline/latest/userguide/pipelines-create-service-role.html)

[GIthub Repository abou Terraform Codepipeline](https://github.com/aws-samples/aws-devops-pipeline-accelerator/blob/main/aws-codepipeline/terraform/pipeline-modules/modules/codepipeline/main.tf)
