# Private AKS Terraform
This quickstart provide terraform code to provision private cluster on AKS. It will provision Azure resources as below:
1. Networking layer such as Vnet, Subnet, Public and Private IP, NSG, etc
2. AKS Private Cluster integrated with previosly created Vnet
3. A jumpbox VM in the same Vnet to try accessing the cluster
4. IAM

## Prerequisites for running the quickstart
Make sure to use Terraform 13 and clone the quickstarts repository
   ```
   git clone https://github.com/zakariakhmd/terraform-private-aks.git
   ```

## Running the quickstart locally

Make sure you have the right access of Azre subscription on your local machine and start the provisioning of AKS and jumpbox VM as below
   ```
   terraform init
   ```
   ```
   terraform apply
   ```

Optional: Before resource provisioning, you might need to run terraform code validation and run the dry-run of terraform as below
   ```
   terraform validate
   ```
   ```
   terraform plan
   ```

Explanation in details in this [medium article](https://medium.com/@paveltuzov/create-a-fully-private-aks-infrastructure-with-terraform-e92358f0bf65?source=friends_link&sk=124faab1bb557c25c0ed536ae09af0a3).