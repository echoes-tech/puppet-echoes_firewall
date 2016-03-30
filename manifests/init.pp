class echoes_firewall (
  $allow_icmp              = false,
  $allow_icmpv6            = false,
  $ipv4_allow_addr_for_ssh = [],
  $ipv6_allow_addr_for_ssh = [],
  $ipv4_forward_ensure     = present,
  $ipv4_forward_policy     = 'drop',
  $ipv4_input_ensure       = present,
  $ipv4_input_policy       = 'drop',
  $ipv4_output_ensure      = present,
  $ipv4_output_policy      = 'drop',
  $ipv6_forward_ensure     = present,
  $ipv6_forward_policy     = 'drop',
  $ipv6_input_ensure       = present,
  $ipv6_input_policy       = 'drop',
  $ipv6_output_ensure      = present,
  $ipv6_output_policy      = 'drop',
  $manage_ipv4             = true,
  $manage_ipv6             = true,
) {
  validate_bool($allow_icmp)
  validate_bool($allow_icmpv6)
  validate_array($ipv4_allow_addr_for_ssh)
  validate_array($ipv6_allow_addr_for_ssh)
  validate_re($ipv4_forward_ensure, '^(present|absent)$',
    "echoes_firewall::ipv4_forward_ensure is <${ipv4_forward_ensure}> and \
    must be 'present' or 'absent'.")
  validate_re($ipv4_forward_policy, '^(accept|drop|queue|return)$',
    "echoes_firewall::ipv4_forward_policy is <${ipv4_forward_policy}> and \
    must be 'accept', 'drop', 'queue' or 'return'.")
  validate_re($ipv4_input_ensure, '^(present|absent)$',
    "echoes_firewall::ipv4_input_ensure is <${ipv4_input_ensure}> and \
    must be 'present' or 'absent'.")
  validate_re($ipv4_input_policy, '^(accept|drop|queue|return)$',
    "echoes_firewall::ipv4_input_policy is <${ipv4_input_policy}> and \
    must be 'accept', 'drop', 'queue' or 'return'.")
  validate_re($ipv4_output_ensure, '^(present|absent)$',
    "echoes_firewall::ipv4_output_ensure is <${ipv4_output_ensure}> and \
    must be 'present' or 'absent'.")
  validate_re($ipv4_output_policy, '^(accept|drop|queue|return)$',
    "echoes_firewall::ipv4_output_policy is <${ipv4_output_policy}> and \
    must be 'accept', 'drop', 'queue' or 'return'.")
  validate_re($ipv6_forward_ensure, '^(present|absent)$',
    "echoes_firewall::ipv6_forward_ensure is <${ipv6_forward_ensure}> and \
    must be 'present' or 'absent'.")
  validate_re($ipv6_forward_policy, '^(accept|drop|queue|return)$',
    "echoes_firewall::ipv6_forward_policy is <${ipv6_forward_policy}> and \
    must be 'accept', 'drop', 'queue' or 'return'.")
  validate_re($ipv6_input_ensure, '^(present|absent)$',
    "echoes_firewall::ipv6_input_ensure is <${ipv6_input_ensure}> and \
    must be 'present' or 'absent'.")
  validate_re($ipv6_input_policy, '^(accept|drop|queue|return)$',
    "echoes_firewall::ipv6_input_policy is <${ipv6_input_policy}> and \
    must be 'accept', 'drop', 'queue' or 'return'.")
  validate_re($ipv6_output_ensure, '^(present|absent)$',
    "echoes_firewall::ipv6_output_ensure is <${ipv6_output_ensure}> and \
    must be 'present' or 'absent'.")
  validate_re($ipv6_output_policy, '^(accept|drop|queue|return)$',
    "echoes_firewall::ipv6_output_policy is <${ipv6_output_policy}> and \
    must be 'accept', 'drop', 'queue' or 'return'.")
  validate_bool($manage_ipv4)
  validate_bool($manage_ipv6)

  resources { 'firewall':
    purge  => true,
    ignore => [
      '-j fail2ban-*',
      ],
  }

  resources { 'firewallchain':
    purge  => true,
    ignore => [
      '-j fail2ban-*',
      ],
  }

  if $manage_ipv4 {
    $post_ipv4_class = 'echoes_firewall::post'
    $pre_ipv4_class  = 'echoes_firewall::pre'

    class { [$pre_ipv4_class, $post_ipv4_class]: }

    firewall { '100 allow SSH access':
      dport  => [ 22 ],
      proto  => 'tcp',
      action => 'accept',
    }

    if (size($ipv4_allow_addr_for_ssh) > 0) {
      Firewall['100 allow SSH access'] {
        source => $ipv4_allow_addr_for_ssh,
      }
    }
  } else {
    $post_ipv4_class = []
    $pre_ipv4_class  = []
  }


  if $manage_ipv6 {
    $post_ipv6_class = 'echoes_firewall::post_ipv6'
    $pre_ipv6_class  = 'echoes_firewall::pre_ipv6'

    class { [$pre_ipv6_class, $post_ipv6_class]: }

    firewall { '100 allow SSH access - IPv6':
      dport    => [ 22 ],
      proto    => 'tcp',
      action   => 'accept',
      provider => 'ip6tables',
    }

    if (size($ipv6_allow_addr_for_ssh) > 0) {
      Firewall['100 allow SSH access - IPv6'] {
        source => $ipv6_allow_addr_for_ssh,
      }
    }
  } else {
    $post_ipv6_class = []
    $pre_ipv6_class  = []
  }

  Firewall {
    before  => Class[$post_ipv4_class, $post_ipv6_class],
    require => Class[$pre_ipv4_class, $pre_ipv6_class],
  }

  class { 'firewall': }
}
