node 'lin-test.rackstage.co.uk' {

	include 'apache'
	include 'mysql'

	apache::module { 'rewrite':
	}

	$workspace_public = [
		'/var/www/vhosts',
		'/var/www/vhosts/lin-test.rackstage.co.uk',
		'/var/www/vhosts/lin-test.rackstage.co.uk/public_html'
	]

	file { $workspace_public:
		ensure => directory,
	}

	class { 'wordpress':
		install => 'source',
		install_source => 'http://wordpress.org/latest.tar.gz',
		install_dirname => 'vhosts/lin-test.rackstage.co.uk/public_html',
		install_postcommand => 'mv /var/www/vhosts/lin-test.rackstage.co.uk/public_html/wordpress/* /var/www/vhosts/lin-test.rackstage.co.uk/public_html/',
		web_server => 'apache',
		web_server_template => 'example-resources/wordpress/apache_vhost_conf.erb',
		web_virtualhost => 'wordpress',
		options => {
			'ServerName' => 'cms-deploy-test-lin',
			'ServerAlias' => 'cms-deploy-test-lin lin-test.rackstage.co.uk',
			'DocumentRoot' => '/var/www/vhosts/lin-test.rackstage.co.uk/public_html',
		},
		db_name => 'lintest_wpdb2',
		db_user => 'lintest_user',
		db_password => 'YsbaFTP875qn_xKqQWY5',
		db_host => '127.0.0.1',
		require => [Class['mysql'], Class['apache'],
			    Apache::Module['rewrite'], File[$workspace_public]]
	}
}
