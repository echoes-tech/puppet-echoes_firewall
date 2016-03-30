# Private class
class echoes_firewall::post_ipv6 inherits echoes_firewall {
  if $caller_module_name != $module_name {
    fail("Use of private class ${name} by ${caller_module_name}")
  }

  firewall { '996 - IPv6':
    action   => 'reject',
    reject   => 'icmp6-adm-prohibited',
    provider => 'ip6tables',
  }->

  firewall { '997 log IPv6 input chain':
    chain      => 'INPUT',
    jump       => 'LOG',
    log_prefix => '[IPTABLES INPUT]: ',
  }->
  firewall { '998 log IPv6 forward chain':
    chain      => 'FORWARD',
    jump       => 'LOG',
    log_prefix => '[IPTABLES FORWARD]: ',
  }->
  firewall { '999 log IPv6 output chain':
    chain      => 'OUTPUT',
    jump       => 'LOG',
    log_prefix => '[IPTABLES OUTPUT]: ',
    before     => undef,
  }
}
