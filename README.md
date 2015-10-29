Supported OS:

- CentOS 6.5
- CentOS 7.0

Deployment guide:

1. Run:

   ```
   sudo ./yum-install.sh
   ./ruby-install.sh
   ./terraform-install.sh
   source $HOME/.bashrc
   ```

2. Copy puppet/hiera/hieradata/common.yaml-[small|medium|large] to common.yaml.
   Update it, if needed.

3. Copy main.tf-[small|medium|large] to main.tf.

4. Prepare .pem file to be used for SSH connections.

5. Copy terraform.tfvars.stub to terraform.tfvars.  Update it with actual
   values.  You may also override other values from variables.tf.

6. To create instances, run:

   ```
   terraform apply
   ```

   If "Error launching source instance: InvalidParameterValue: Value () for
   parameter groupId is invalid. The value cannot be empty" error appears,
   just restart the command.

7. To connect to any instance:

   ```
   ssh -i <your .pem file> <SSH user>@<IP address>
   ```

   You can find SSH users for all AMIs in variables.tf.

8. To destroy instances, run:

   ```
   terraform destroy
   ```
