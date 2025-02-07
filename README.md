# Garden Example for Terraform Lambda

This example project demonstrates how to use Garden to create on-demand environments for an AWS Lambda stack provisioned via Terraform—and in general manage Terraform projects with Garden.

> [!NOTE]
> You'll need to update some values in the project level Garden config file for this project to work. See instructions below.

> [!WARNING]  
> The dynamic backend config functionality used is currently only available on a Garden edge release but due to be released in Garden 0.13.54.

## Requirements

- The Garden CLI installed on your system. See [instructions here](https://docs.garden.io/getting-started/installation)
- An AWS S3 bucket for storing Terraform state
- Access to AWS from the host running Garden and permissions to create folders in the Terraform state bucket and to create Lambda functions

Note that this project requires functionality that is currently only available on a Garden edge release but will be properly released with Garden 0.13.54. To check your Garden version, run:

```console
garden version
```

If it's lower than 0.13.54, you can use the edge release by running the following after installing Garden:

```console
garden self-update edge-bonsai
```

(Bonsai refers to the `0.13` release branch).

## Using this project

### Quickstart

To deploy this project, you can run:

```console
AWS_S3_BUCKET=<name-of-aws-s3-bucket> AWS_REGION=<name-of-aws-region> garden deploy
```

This will create the AWS lambdas and a directory for the Terraform state in you AWS bucket.

To test the project, you can run:

```console
AWS_S3_BUCKET=<name-of-aws-s3-bucket> AWS_REGION=<name-of-aws-region> garden test 
```

### Full set up

To properly set up this project, follow the steps below:

### Step 1 — Add your variables to the config

In the project level Garden config file at `project.garden.yml`, set the name of your AWS S3 bucket and AWS region:

```yaml
# In project.garden.yml
apiVersion: "garden.io/v1"
kind: Project
#...

variables:
  # Replace this with your own backend config. In this project we assume the S3 bucket already exists.
  backendConfig:
    bucket: ${local.env.AWS_S3_BUCKET || "<my-terraform-state-bucket>"} # <--- Update this value
    region: ${local.env.AWS_REGION || "<my-aws-region>"} # <--- Update this value
```

With this configuration, Garden will first look for these values in the environment and then fallback to the values specified. Feel free to change this to suit your needs.

You can verify that things work as expected by running:

```console
garden deploy
```

### Step 2 – Import the project in Garden Enterprise (optional)

> [!NOTE]
The following only applies to Garden Enterprise users and assumes that you have a fork of this project available in your own VCS provider (i.e. GitHub or GitLab).

Go to the Project page on your Garden Enterprise instance and click the "Add project" button in the top right corner to import the project.

Select the project in the pop up dialog. If you don't see your project, it's probably because your GitHub / GitLab app doesn't have access to it:
- **For GitHub** you need to make sure the app has permissions to access the repository, [see instructions here](https://cloud.docs.garden.io/guides/github#installing-the-github-app).
- **For GitLab** you need to grant the access token access to the repository, [see instructions here](https://cloud.docs.garden.io/guides/gitlab#creating-an-access-token).

Once you've imported the project, make note of the project ID. It's visible on the project Live page and on the Settings page for the project.

### Step 3 — Connect the project to Garden Enterprise (optional)

> [!NOTE]
The following only applies to Garden Cloud/Enterprise users.

Set the project ID and your Garden Cloud/Enterprise domain in the project level Garden config file at
`project.garden.yml` like so:

```yaml
apiVersion: "garden.io/v1"
kind: Project
#...

# Replace this with your project ID and Garden Cloud/Enterprise domain
# You need do this AFTER you import your project in Garden Cloud/Enterprise
id: <garden-project-id> # <--- Update this value
domain: <https://my-garden-app.app.garden> # <--- Update this value

```

Now log in by running:

```console
garden login
```

...and then try deploying again with:

```console
garden deploy
```

This time you should see the command results in your Garden Cloud/Enterprise instance

## About the project

The project contains a few AWS lambda functions and a "fake" DynamoDB Terraform module that just echoes out a string.

The main goal is to demonstrate how to use Garden to create isolated, on-demand environments for projects like this.

To this end we:

- Define a variable called `namespaceName` in the `project.garden.yml` config that should be unique to the environment (e.g. in dev it uses the user name, for CI the commit hash).
- Set the `backendConfig` dynamically for the individual actions based on the `namespaceName` variable (see e.g. `hello-fn/garden.yml`). This essentially ensures that the environments are isolated and can be created on-demand which is something Terraform doesn't really support natively.
- Pass the output of the (fake) DynamoDB resource to the functions to demonstrate how we share these sort of values (see e.g. how the `db_host` output gets set as an environment variable in the lambdas).
- Have each Terraform module be its own stack, as opposed to having a single `main.tf` file that imports the modules. This gives Garden more control and allows you to easily deploy/destroy individual functions and benefit from caching.

Note that the project also has a test action (see the `./e2e-test-runner/garden.yml` config file) that runs end-to-end tests that validates the responses from the other lambdas. If you e.g. change the response of the `hell-fn` from `Hello!` to, say, `Hola!` and run `garden test`, you'll notice that Garden re-deploys the changed function, re-runs the test, and you should see it fail.
