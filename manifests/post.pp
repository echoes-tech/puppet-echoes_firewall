# Private class
class echoes_firewall::post inherits echoes_firewall {
  if $caller_module_name != $module_name {
    fail("Use of private class ${name} by ${caller_module_name}")
  }

  firewall { '997 log input chain':
    chain      => 'INPUT',
    jump       => 'LOG',
    log_prefix => '[IPTABLES INPUT]: ',
  }->
  firewall { '998 log forward chain':
    chain      => 'FORWARD',
    jump       => 'LOG',
    log_prefix => '[IPTABLES FORWARD]: ',
  }->
  firewall { '999 log output chain':
    chain      => 'OUTPUT',
    jump       => 'LOG',
    log_prefix => '[IPTABLES OUTPUT]: ',
    before     => undef,
  }
}
