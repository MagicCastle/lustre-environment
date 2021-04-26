class profile::base {
  include epel
  package{'vim':}
  package{'clustershell':}

  $instances = lookup('terraform.instances')
$host_template = @(END)
127.0.0.1 localhost localhost.localdomain localhost4 localhost4.localdomain4
<% @instances.each do |key, values| -%>
<%= values['local_ip'] %> <%= key %> <% if values['tags'].include?('puppet') %>puppet<% end %>
<% end -%>
END

  file { '/etc/hosts':
    ensure  => file,
    content => inline_template($host_template)
  }
}
