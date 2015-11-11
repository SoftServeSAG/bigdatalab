#
# Installs and configures all the components and resources
# which are common to every workstation or server in scope of BigDataLab
#

class profiles::common (
  $aws_access_key,
  $aws_secret_key,
  $aws_region,
  $aws_security_group,
  $aws_ssh_username,
  $aws_ami,
  $aws_security_group_id,
  $aws_subnetId,
  $aws_tag_env,
  $aws_tag_owner) {
}