node default {
  include profile::base

  yumrepo { 'lustre-client':
    baseurl  => 'https://downloads.whamcloud.com/public/lustre/latest-2.12-release/el7/client/',
    gpgcheck => 0
  }
  package { ['kmod-lustre-client', 'lustre-client']: }
}

node /^(mds|oss)(\d+)$/ {
  $type  = $1
  $index = $2

  include profile::base

  yumrepo { 'lustre-server':
    baseurl  => 'https://downloads.whamcloud.com/public/lustre/latest-2.12-release/el7/server/',
    gpgcheck => 0
  }
  yumrepo { 'e2fsprogs':
    baseurl  => 'https://downloads.whamcloud.com/public/e2fsprogs/latest/el7/',
    gpgcheck => 0
  }

  package { ['lustre', 'kmod-lustre-osd-ldiskfs']: }
  reboot { 'after_kmod-lustre':
    subscribe => Package['kmod-lustre-osd-ldiskfs'],
  }
}
