#
# Apache logs generator profile
#

class profiles::log_generator {

  require profiles::linux

  include ::log_generator

}