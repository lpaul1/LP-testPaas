name "csmgr"
description "CloudStack Platform Manager"

run_list( 
   "recipe[build-essential]",
   "recipe[selinux::permissive]",
   "recipe[ntp]",
   "recipe[mysql::server]",
   "recipe[csinstaller::mgmt_server]"
   #"recipe[csinstaller::setup_zone]"
)

override_attributes(
  "mysql" => { 
    "server_root_password" => "fr3sca", 
    "tunable" => {  
      "innodb_lock_wait_timeout" => "600",
      "binlog_format" => "ROW",
      "innodb_rollback_on_timeout" => "1",
      "log_bin" => "mysql-bin"
    },
    "server_debian_password" => "fr3sca",
    "bind_address" => "localhost",
    "server_repl_password" => "fr3sca"
  },
  "ntp" => {
    "packages" => [ "ntp" ],
    "service" => "ntpd",
    "servers" => [
      "0.rhel.pool.ntp.org",
      "1.rhel.pool.ntp.org",
      "2.rhel.pool.ntp.org"
    ],
  }
)
