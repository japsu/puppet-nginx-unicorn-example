class nginx {
    define site () {
        file {
            "/etc/nginx/sites-available/$title":
                notify => Service['nginx'],
                ensure => present,
                source => ["puppet:///modules/nginx/$title.conf@$hostname",
                           "puppet:///modules/nginx/$title.conf"];
            "/etc/nginx/sites-enabled/$title":
                notify => Service['nginx'],
                ensure => link,
                target => "/etc/nginx/sites-available/$title";
        }
    }

    define proxy ($target) {
        file {
            "/etc/nginx/sites-available/$title":
                notify => Service['nginx'],
                ensure => present,
                content => template('nginx/proxy.conf.erb');
            "/etc/nginx/sites-enabled/$title":
                notify => Service['nginx'],
                ensure => link,
                target => "/etc/nginx/sites-available/$title";
        }
    }

    package {
        'nginx':
            ensure => present
    }

    service {
        'nginx':
            ensure => running,
            enable => true,
            hasstatus => true,
            hasrestart => true;
    }

    user {
        'www-data':
            ensure => present
    }

    file {
        '/etc/nginx':
            ensure => directory;
        '/etc/nginx/sites-available':
            ensure => directory;
        '/etc/nginx/sites-enabled':
            ensure => directory;
        '/etc/nginx/nginx.conf':
            notify => Service['nginx'],
            ensure => present,
            source => ["puppet:///modules/nginx/nginx.conf@$hostname",
                       'puppet:///modules/nginx/nginx.conf'];
        '/var/www':
            ensure => directory,
            mode => 0755;
        '/var/www/index.html':
            ensure => present,
            content => template('nginx/index.html.erb'),
            mode => 0644;
    }

    nginx::site {
        'default':
    }
}