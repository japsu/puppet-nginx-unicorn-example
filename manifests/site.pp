node redmine {
    include nginx
    include unicorn

    nginx::proxy {
        'redmine.example.com':
            target => 'http://localhost:8080';
    }

    unicorn::instance {
        'redmine':
            user => 'redmine',
            app_root => '/srv/redmine/redmine-2.3',
            listen => 'localhost:8080'
    }
}
