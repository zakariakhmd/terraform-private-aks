# Private AKS Terraform
This quickstart shows method invocation and state persistent capabilities of Dapr through a distributed calculator where each operation is powered by a different service written in a different language/framework:

## Prerequisites for running the quickstart
Clone the quickstarts repository
   ```
   git clone https://github.com/zakariakhmd/terraform-private-aks.git
   ```

## Running the quickstart locally

These instructions start the provisioning of AKS and jumpbox VM as below
   ```
   terraform init
   ```
   ```
   terraform plan
   ```

Explanation in details in this [medium article](https://medium.com/@paveltuzov/create-a-fully-private-aks-infrastructure-with-terraform-e92358f0bf65?source=friends_link&sk=124faab1bb557c25c0ed536ae09af0a3).