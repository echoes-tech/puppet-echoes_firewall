# echoes_firewall

[![Build Status](https://travis-ci.org/echoes-tech/puppet-echoes_firewall.svg?branch=master)]
(https://travis-ci.org/echoes-tech/puppet-echoes_firewall)
[![Flattr Button](https://api.flattr.com/button/flattr-badge-large.png "Flattr This!")]
(https://flattr.com/submit/auto?user_id=echoes&url=https://forge.puppetlabs.com/echoes/echoes_firewall&title=Puppet%20module%20to%20manage%20firewall%20rules&lang=en_GB&category=software "Puppet module to manage firewall rules")

#### Table of Contents

1. [Overview](#overview)
2. [Module Description - What the module does and why it is useful](#module-description)
3. [Setup - The basics of getting started with firewall](#setup)
    * [Beginning with firewall](#beginning-with-firewall)
4. [Usage - Configuration options and additional functionality](#usage)
    * [Allow SSH for only one IPv4](#allow-ssh-for-only-one-ipv4)
5. [Reference - An under-the-hood peek at what the module is doing and how](#reference)
6. [Limitations - OS compatibility, etc.](#limitations)
7. [Development - Guide for contributing to the module](#development)
8. [Contributors](#contributors)

## Overview

Puppet module to manage firewall rules.

## Module Description

This module is an implementation of the recommendations of the [puppetlabs-firewall](https://forge.puppetlabs.com/puppetlabs/firewall) module.
See more: https://forge.puppetlabs.com/puppetlabs/firewall#beginning-with-firewall

## Setup

### Beginning with firewall

```puppet
include 'echoes_firewall'
```
## Usage

### Allow SSH for only one IPv4

```puppet
class { echoes_firewall:
  allow_ipv4_for_ssh => [ '192.168.1.1' ],
}
```

## Reference

### Classes

#### Public Classes

* echoes_firewall: Main class, includes all other classes.

#### Private classes

* echoes_firewall::post:      Handles the last rules for IPv4.
* echoes_firewall::post_ipv6: Handles the last rules for IPv6.
* echoes_firewall::pre:       Handles the first rules for IPv4.
* echoes_firewall::pre_ipv6:  Handles the first rules for IPv6.

#### Parameters

The following parameters are available in the `::echoes_firewall` class:

##### `allow_icmp`

Specifies whether ICMP is allowed. Valid options: boolean. Default value: false

##### `allow_icmpv6`

Specifies whether ICMPv6 is allowed. Valid options: boolean. Default value: false

##### `ipv4_allow_addr_for_ssh`

Specifies which IPv4 addresses are allowed to established a SSH connection. Valid options: array. Default value: []

##### `ipv6_allow_addr_for_ssh`

Specifies which IPv6 addresses are allowed to established a SSH connection. Valid options: array. Default value: []

##### `ipv4_forward_ensure`

Specifies whether the IPv4 forward firewall chain is present. Valid options: 'present' or 'absent'. Default value: present

##### `ipv4_forward_policy`

Specifies the action the packet will perform when the end of the the IPv4 forward firewall chain is reached. Valid options: 'accept', 'drop', 'queue' or 'return'. Default value: 'drop'

##### `ipv4_input_ensure`

Specifies whether the IPv4 input firewall chain is present. Valid options: 'present' or 'absent'. Default value: present

##### `ipv4_input_policy`

Specifies the action the packet will perform when the end of the the IPv4 input firewall chain is reached. Valid options: 'accept', 'drop', 'queue' or 'return'. Default value: 'drop'

##### `ipv4_output_ensure`

Specifies whether the IPv4 output firewall chain is present. Valid options: 'present' or 'absent'. Default value: present

##### `ipv4_output_policy`

Specifies the action the packet will perform when the end of the the IPv4 output firewall chain is reached. Valid options: 'accept', 'drop', 'queue' or 'return'. Default value: 'drop'

##### `ipv6_forward_ensure`

Specifies whether the IPv6 forward firewall chain is present. Valid options: 'present' or 'absent'. Default value: present

##### `ipv6_forward_policy`

Specifies the action the packet will perform when the end of the the IPv6 forward firewall chain is reached. Valid options: 'accept', 'drop', 'queue' or 'return'. Default value: 'drop'

##### `ipv6_input_ensure`

Specifies whether the IPv6 input firewall chain is present. Valid options: 'present' or 'absent'. Default value: present

##### `ipv6_input_policy`

Specifies the action the packet will perform when the end of the the IPv6 input firewall chain is reached. Valid options: 'accept', 'drop', 'queue' or 'return'. Default value: 'drop'

##### `ipv6_output_ensure`

Specifies whether the IPv6 output firewall chain is present. Valid options: 'present' or 'absent'. Default value: present

##### `ipv6_output_policy`

Specifies the action the packet will perform when the end of the the IPv6 output firewall chain is reached. Valid options: 'accept', 'drop', 'queue' or 'return'. Default value: 'drop'

##### `manage_ipv4`

Tells Puppet whether to manage the IPv4 firewall. Valid options: boolean. Default value: true

##### `manage_ipv6`

Tells Puppet whether to manage the IPv6 firewall. Valid options: boolean. Default value: true

## Limitations

RedHat and Debian family OSes are officially supported. Tested and built on Debian and CentOS.

##Development

[Echoes Tech & Labs](https://www.echoes.fr) modules on the Puppet Forge are open projects, and community contributions are essential for keeping them great.

[Fork this module on GitHub](https://github.com/echoes-tech/puppet-echoes_firewall/fork)

## Contributors

The list of contributors can be found at: https://github.com/echoes-tech/puppet-echoes_firewall/graphs/contributors
