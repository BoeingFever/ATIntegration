# ATIntegration

ansible terraform aws integration self study scripts

1 line command to provision some minor resources and 1 ec2 then configure the new ec2 instance remotely from your control node

## pre-requisite
your current iam user have admin rights, have your iam user access key and secret
Have your ssh key pair configured already on aws console.
store the private key XXX.pem file for connecting to the ec2 you're going to provision on your current linux machine (local or itself also on cloud), on which terraform and ansible is running
