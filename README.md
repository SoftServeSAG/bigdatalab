1. Run:

   ```
   sudo ./yum-install.sh
   ./ruby-install.sh
   ./terraform-install.sh
   source $HOME/.bashrc
   ```

2. Copy puppet/hiera/hieradata/common.yaml-[small|medium|large] to common.yaml.
   Update common.yaml, if needed.

3. Copy main.tf-[small|medium|large] to main.tf.

4. Prepare .pem file to be used for SSH connections.

5. Copy terraform.tfvars.stub to terraform.tfvars.  Update terraform.tfvars
   with actual values.  You may also override other variables from
   variables.tf.

6. To create instances, run:

   ```
   terraform apply
   ```

   Note: If "Error launching source instance: InvalidParameterValue: Value ()
   for parameter groupId is invalid. The value cannot be empty" error appears,
   just restart the command.

7. To connect to any instance:

   ```
   ssh -i <your .pem file> centos@<IP address>
   ```

8. To destroy instances, run:

   ```
   terraform destroy
   ```
