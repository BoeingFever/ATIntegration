# ATIntegration

ansible terraform aws integration self study scripts

1 line command to provision some minor resources and 1 ec2 then configure the new ec2 instance remotely from your control node

the scripts depend on each other under the same directory structure of this repo, clone it then change directory `cd ATIntegration/terraform` 

then initialise your terraform directory `terraform init` , execute `terraform apply`

## pre-requisite
your current iam user has admin rights
your iam user access key and secret is prepared cuz you will need to fill them in the config files later

Have your ssh key pair configured already on aws console UI.

store the private key XXX.pem file on your current linux machine (no matter your machine is local or in cloud), the pem file is used for connecting to the ec2 you're going to provision later, and on which terraform and ansible will be running
