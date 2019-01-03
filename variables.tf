
variable this_env {
  type = "map"
}

variable peer_env {
  type = "map"
}

variable originate {
  default = "false"
}

variable auto_accept {
  default = "false"
}

variable pub_route_table {}

variable priv_route_tables {
  type = "list"
}
  
