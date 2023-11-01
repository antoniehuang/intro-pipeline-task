# intro-pipeline-task

The goal of this task is to demostratea a data pipeline that ingest data from the data source into Snowflake.

## Repo Structure

The repo is structured as a self contained repo, where the application code of the lambda functions, CI/CD pipelines, infrastrucue code, and sample data are all contained within this repository.

#### Folder strucutre

`./lambas` - contains the lambda's code and tests.

`./data` - contains the sample dataset.

`./terraform` - contains the terraform code for the infra.

`./.github` - contains the GitHub workflows

### Terraform

Terraform is used to provision AWS resources required for the pipeline in this task.

### CI/CD

Lambda is deployed with GitHub Actions and uses OpenID Connect (OIDC) to authenticate with AWS and run AWS CLI commands to update lambda's application code.

### Todos

- [ ] Store lambda's application code on s3
- [ ] Handle boto3 exceptions
- [ ] Add test for the lambda
- [ ] Create workflows for applying terraform changes
