sub perl_info_print_httpd {

	SECTION("apache");
	perl_info_print_table_start();
	perl_info_print_apache();
	perl_info_print_table_end();

	SECTION("Apache Environment");
	perl_info_print_table_start();
	perl_info_print_table_header(2, "Variable", "Value");
	perl_info_print_apache_environment();
	perl_info_print_table_end();

}

sub check_apache {

	return 0 unless (defined($ENV{'SERVER_SOFTWARE'}) && $ENV{'SERVER_SOFTWARE'}=~/apache/i);
	return 1;
} 

sub perl_info_print_apache {

	return unless (check_apache());

	my  ($version, $major, $minor, $patch, $user, $group, $root, @mods) = ("Not detected by App::Info. See ENVs.") x 7;
	my $apache = App::Info::HTTPD::Apache->new;
	if ($apache->installed) {
		$version = $apache->version; 
		$major =  $apache->major_version;
		$minor =  $apache->minor_version;
		$patch =  $apache->patch_version;
		$user  =  $apache->user;
		$group =  $apache->group;
		$root  =  $apache->httpd_root;
		@mods  =  $apache->static_mods;
	} 

	perl_info_print_table_row(2, "Apache Version", "$version");
	perl_info_print_table_row(2, "Apache Major Version", "$major");
	perl_info_print_table_row(2, "Apache Minor Version", "$minor");
	perl_info_print_table_row(2, "Apache Patch Version", "$patch");
	perl_info_print_table_row(2, "Hostname:Port", "$ENV{'SERVER_NAME'}:$ENV{'SERVER_PORT'}");
	perl_info_print_table_row(2, "User/Group", "$user / $group");
	perl_info_print_table_row(2, "Server Root", "$root");
	($apache->installed) ?
	perl_info_print_table_row(2, "Loaded Modules", "@mods"):
	perl_info_print_table_row(2, "Loaded Modules", "Not detected by App::Info. See ENVs.");
}

sub perl_info_print_apache_environment {

	return unless (check_apache());

	perl_info_print_table_row(2, "DOCUMENT_ROOT", "$ENV{'DOCUMENT_ROOT'} ");
	perl_info_print_table_row(2, "HTTP_ACCEPT", "$ENV{'HTTP_ACCEPT'} ");
	perl_info_print_table_row(2, "HTTP_ACCEPT_CHARSET", "$ENV{'HTTP_ACCEPT_CHARSET'} ");
	perl_info_print_table_row(2, "HTTP_ACCEPT_ENCODING", "$ENV{'HTTP_ACCEPT_ENCODING'} ");
	perl_info_print_table_row(2, "HTTP_ACCEPT_LANGUAGE", "$ENV{'HTTP_ACCEPT_LANGUAGE'} ");
	perl_info_print_table_row(2, "HTTP_CONNECTION", "$ENV{'HTTP_CONNECTION'} ");
	perl_info_print_table_row(2, "HTTP_HOSTS", "$ENV{'HTTP_HOSTS'} ");
	perl_info_print_table_row(2, "HTTP_KEEP_ALIVE", "$ENV{'HTTP_KEEP_ALIVE'} ");
	perl_info_print_table_row(2, "HTTP_USER_AGENT", "$ENV{'HTTP_USER_AGENT'} ");
	perl_info_print_table_row(2, "PATH", "$ENV{'PATH'} ");
	perl_info_print_table_row(2, "REMOTE_ADDR", "$ENV{'REMOTE_ADDR'} ");
	perl_info_print_table_row(2, "REMOTE_HOST", "$ENV{'REMOTE_HOST'} ");
	perl_info_print_table_row(2, "REMOTE_PORT", "$ENV{'REMOTE_PORT'} ");
	perl_info_print_table_row(2, "SCRIPT_FILENAME", "$ENV{'SCRIPT_FILENAME'} ");
	perl_info_print_table_row(2, "SCRIPT_URI", "$ENV{'SCRIPT_URI'} ");
	perl_info_print_table_row(2, "SCRIPT_URL", "$ENV{'SCRIPT_URL'} ");
	perl_info_print_table_row(2, "SERVER_ADDR", "$ENV{'SERVER_ADDR'} ");
	perl_info_print_table_row(2, "SERVER_ADMIN", "$ENV{'SERVER_ADMIN'} ");
	perl_info_print_table_row(2, "SERVER_NAME", "$ENV{'SERVER_NAME'} ");
	perl_info_print_table_row(2, "SERVER_PORT", "$ENV{'SERVER_PORT'} ");
	perl_info_print_table_row(2, "SERVER_SIGNATURE", "$ENV{'SERVER_SIGNATURE'} ");
	perl_info_print_table_row(2, "SERVER_SOFTWARE", "$ENV{'SERVER_SOFTWARE'} ");
	perl_info_print_table_row(2, "GATEWAY_INTERFACE", "$ENV{'GATEWAY_INTERFACE'} ");
	perl_info_print_table_row(2, "SERVER_PROTOCOL", "$ENV{'SERVER_PROTOCOL'} ");
	perl_info_print_table_row(2, "REQUEST_METHOD", "$ENV{'REQUEST_METHOD'} ");
	perl_info_print_table_row(2, "QUERY_STRING", "$ENV{'QUERY_STRING'} ");
	perl_info_print_table_row(2, "REQUEST_URI", "$ENV{'REQUEST_URI'} ");
	perl_info_print_table_row(2, "SCRIPT_NAME", "$ENV{'SCRIPT_NAME'} ");  
}
1;
