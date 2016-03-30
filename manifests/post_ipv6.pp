# Private class
class echoes_firewall::post_ipv6 inherits echoes_firewall {
  if $caller_module_name != $module_name {
    fail("Use of private class ${name} by ${caller_module_name}")
  }

  firewall { '996 - IPv6':
    action   => 'reject',
    reject   => 'icmp6-adm-prohibited',
    provider => 'ip6tables',
    before   => undef,
  }
}
