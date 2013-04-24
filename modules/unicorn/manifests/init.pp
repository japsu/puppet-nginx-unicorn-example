class unicorn {
    define instance(
        $app_root,
        $user='www-data',
        $listen='127.0.0.1:3000',
        $unicorn='unicorn_rails'
    ) {
        file {
            "/etc/unicorn/$title.conf":
                notify => Service['unicorn'],
                ensure => present,
                content => template('unicorn/instance.conf.erb');
            "/etc/unicorn/$title.unicorn.rb":
                notify => Service['unicorn'],
                ensure => present,
                content => template('unicorn/unicorn.rb.erb');
        }
    }

    file {
        '/etc/init.d/unicorn':
            ensure => present,
            mode => 0755,
            source => ["puppet:///modules/unicorn/init_script.sh@$hostname",
                       'puppet:///modules/unicorn/init_script.sh'];
        '/etc/unicorn':
            ensure => directory;
    }

    service {
        'unicorn':
            ensure => running,
            enable => true,
            hasstatus => true,
            hasrestart => true;
    }
}