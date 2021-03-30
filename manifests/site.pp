node default {
  package{'vim':}


  yumrepo { 'lustre-client':
    baseurl => 'https://downloads.whamcloud.com/public/lustre/latest-2.12-release/el7/client/',
    gpgcheck => 0
  }
  package { ['kmod-lustre-client', 'lustre-client']: }

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

node 'mds1' {
  package{'vim':}

  yumrepo { 'lustre-server':
    baseurl => 'https://downloads.whamcloud.com/public/lustre/latest-2.12-release/el7/server/',
    gpgcheck => 0
  }
  yumrepo { 'e2fsprogs':
    baseurl => 'https://downloads.whamcloud.com/public/e2fsprogs/latest/el7/',
    gpgcheck => 0
  }

  package { ['lustre', 'kmod-lustre-osd-ldiskfs']: }
}

node /oss\d+/ {
  package{'vim':}

  yumrepo { 'lustre-server':
    baseurl => 'https://downloads.whamcloud.com/public/lustre/latest-2.12-release/el7/server/',
    gpgcheck => 0
  }
  yumrepo { 'e2fsprogs':
    baseurl => 'https://downloads.whamcloud.com/public/e2fsprogs/latest/el7/',
    gpgcheck => 0
  }

  package { ['lustre', 'kmod-lustre-osd-ldiskfs']: }
}
