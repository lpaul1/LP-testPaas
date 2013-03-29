name "db_master"
description "Master database server"

all_env = [
  "role[base]",
  "recipe[mysql::server]",
  "recipe[hello_app::db_master]"

]

run_list(all_env)

env_run_lists(
  "_default" => all_env,
  "prod" => all_env,
  "dev" => all_env,
)
