# Private class
class echoes_firewall::pre_ipv6 inherits echoes_firewall {
  if $caller_module_name != $module_name {
    fail("Use of private class ${name} by ${caller_module_name}")
  }

  Firewall {
    require => undef,
  }

  # Default policies
  firewallchain { 'FORWARD:filter:IPv6':
    ensure => $echoes_firewall::ipv6_forward_ensure,
    policy => $echoes_firewall::ipv6_forward_policy,
  }->
  firewallchain { 'INPUT:filter:IPv6':
    ensure => $echoes_firewall::ipv6_input_ensure,
    policy => $echoes_firewall::ipv6_input_policy,
  }->
  firewallchain { 'OUTPUT:filter:IPv6':
    ensure => $echoes_firewall::ipv6_output_ensure,
    policy => $echoes_firewall::ipv6_output_policy,
  }

  if $echoes_firewall::allow_icmpv6 {
    firewall { '000 Accept all ICMPv6':
      proto  => 'ipv6-icmp',
      action => 'accept',
    }
  }

  # Enable loopback traffic
  firewall { '001 Accept all IPv6 to lo interface':
    proto    => 'all',
    iniface  => 'lo',
    action   => 'accept',
    provider => 'ip6tables',
  }->
  firewall { '002 Reject local IPv6 traffic not on loopback interface':
    iniface     => '! lo',
    proto       => 'all',
    destination => '::1/128',
    action      => 'reject',
    provider    => 'ip6tables',
  }->

  # Enable statefull rules (after that, only need to allow NEW conections)
  firewall { '003 Accept IPv6 related established rules':
    proto    => 'all',
    state    => ['RELATED', 'ESTABLISHED'],
    action   => 'accept',
    provider => 'ip6tables',
  }->

  # Drop invalid state packets
  firewall { '004 Drop invalid IPv6 state packets':
    state    => ['INVALID'],
    action   => 'drop',
    provider => 'ip6tables',
  }
}
