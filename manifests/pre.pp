# Private class
class echoes_firewall::pre inherits echoes_firewall {
  if $caller_module_name != $module_name {
    fail("Use of private class ${name} by ${caller_module_name}")
  }

  Firewall {
    require => undef,
  }

  # Default policies
  firewallchain { 'FORWARD:filter:IPv4':
    ensure => $echoes_firewall::ipv4_forward_ensure,
    policy => $echoes_firewall::ipv4_forward_policy,
    purge  => true,
  }->
  firewallchain { 'INPUT:filter:IPv4':
    ensure => $echoes_firewall::ipv4_input_ensure,
    policy => $echoes_firewall::ipv4_input_policy,
    purge  => true,
    ignore => [
      '-j fail2ban-*',
      ],
  }->
  firewallchain { 'OUTPUT:filter:IPv4':
    ensure => $echoes_firewall::ipv4_output_ensure,
    policy => $echoes_firewall::ipv4_output_policy,
    purge  => true,
  }

  if $echoes_firewall::allow_icmp {
    firewall { '000 Accept all ICMP':
      proto  => 'icmp',
      action => 'accept',
    }
  }

  # Enable loopback traffic
  firewall { '001 Accept all to lo interface':
    proto   => 'all',
    iniface => 'lo',
    action  => 'accept',
  }->
  firewall { '002 Reject local traffic not on loopback interface':
    iniface     => '! lo',
    proto       => 'all',
    destination => '127.0.0.1/8',
    action      => 'reject',
  }->

  # Enable statefull rules (after that, only need to allow NEW conections)
  firewall { '003 Accept related established rules':
    proto  => 'all',
    state  => ['RELATED', 'ESTABLISHED'],
    action => 'accept',
  }->

  # Drop invalid state packets
  firewall { '004 Drop invalid state packets':
    state  => ['INVALID'],
    action => 'drop',
  }
}
