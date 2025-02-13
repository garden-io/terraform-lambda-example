# Garden Example for Terraform Lambda

This example project demonstrates how to use Garden to create on-demand environments for an AWS Lambda stack provisioned via Terraform—and in general manage Terraform projects with Garden.

> [!NOTE]
> The project is currently configured to use an S3 bucket that exists in the Garden internal AWS developer account. See below for how to change this.

> [!WARNING]  
> The dynamic backend config functionality used is still under development and not on the Garden Core `main` branch yet (as of writing). This project won't work until that's complete.

## Using this project

### Quckstart

The following assumes you have access to the Garden Cloud/Enterprise example app (https://example.app.garden) and the Garden developer AWS account.

* Step 1: Authenticate against the Garden developer AWS account
* Step 2: Log in to Garden Cloud/Enterprise with `garden login` (optional)
* Step 3: Deploy the project with `garden deploy`
* Step 4: Test the project with `garden test` (optional)

You should now see the lambda functions on AWS, namespaced to your shell username. The corresponding Terraform state will also be namespaced to your shell username in the S3 bucket used.

### Setting up from scratch

To set this project up from scratch in a different AWS account, do the following:

* Step 1: Create an S3 bucket for the Terraform state
* Step 2: Update the `backendConfig` variable in the `project.garden.yml` file and set the bucket name and
region to the bucket you just created.
* Step 3: Make sure your authenticated against the AWS account from your terminal.
* Step 4: Deploy the project with `garden deploy`.
* Step 5: Test the project with `garden test` (optional)

Note that for now you can only connect to the Garden Cloud/Enterprise example app (https://example.app.garden). If you don't have access you can simply skip logging in.

## About the project

The project contains a few AWS lambda functions and a "fake" DynamoDB Terraform module that just echoes out a string.

The main goal is to demonstrate how to use Garden to create isolated, on-demand environments for projects like this.

To this end we:

- Define a variable called `namespaceName` in the `project.garden.yml` config that should be unique to the environment (e.g. in dev it uses the user name, for CI the commit hash).
- Set the `backendConfig` dynamically for the individual actions based on the `namespaceName` variable (see e.g. `hello-fn/garden.yml`). This essentially ensures that the environments are isolated and can be created on-demand which is something Terraform doesn't really support natively.
- Pass the output of the (fake) DynamoDB resource to the functions to demonstrate how we share these sort of values (see e.g. how the `db_host` output gets set as an environment variable in the lambdas).
- Have each Terraform module be its own stack, as opposed to having a single `main.tf` file that imports the modules. This gives Garden more control and allows you to easily deploy/destroy individual functions and benefit from caching.

Note that the project also has a test action (see the `./e2e-test-runner/garden.yml` config file) that runs end-to-end tests that validates the responses from the other lambdas. If you e.g. change the response of the `hell-fn` from `Hello!` to, say, `Hola!` and run `garden test`, you'll notice that Garden re-deploys the changed function, re-runs the test, and you should see it fail.
