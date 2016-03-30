# Private class
class echoes_firewall::post inherits echoes_firewall {
  if $caller_module_name != $module_name {
    fail("Use of private class ${name} by ${caller_module_name}")
  }

}
