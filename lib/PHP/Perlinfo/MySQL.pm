sub perl_info_print_mysql {

	SECTION("mysql");
	perl_info_print_table_start();
	perl_info_print_table_header(2, "MySQL Support", "installed");
	perl_info_print_table_row(2, "@{[cpan_link('DBI')]} - Database independent interface", mod_check("DBI"));
	perl_info_print_table_row(2, "@{[cpan_link('DBD::mysql')]} - MySQL driver for the DBI", mod_check("DBD::mysql"));  
	perl_info_print_table_row(2, "@{[cpan_link('Net::MySQL')]} - MySQL client interface", mod_check("Net::MySQL"));  
	perl_info_print_table_end();

	perl_info_print_table_start();
	perl_info_print_table_colspan_header(2, "MySQL core programs and scripts");
	perl_info_print_table_row(2, mysql, check_path("mysql"));
	perl_info_print_table_row(2, mysqlaccess, check_path("mysqlaccess"));
	perl_info_print_table_row(2, mysqladmin, check_path("mysqladmin"));
	perl_info_print_table_row(2, mysqld, check_path("mysqld"));
	perl_info_print_table_row(2, mysqldump, check_path("mysqldump"));
	perl_info_print_table_row(2, mysqlshow, check_path("mysqlshow"));
	perl_info_print_table_row(2, isamchk, check_path("isamchk"));
	perl_info_print_table_row(2, isamlog, check_path("isamlog"));
	perl_info_print_table_row(2, safe_mysqld, check_path("safe_mysqld"));
	perl_info_print_table_end();

	if ($flag =~ /INFO_MYSQL/) {

		perl_info_print_table_start();
		perl_info_print_table_colspan_header(2, "MySQL utilities");
		perl_info_print_table_row(2, msql2mysql, check_path("mysql2mysql"));
		perl_info_print_table_row(2, mysqlbug, check_path("mysqlbug"));
		perl_info_print_table_row(2, "perror", check_path("perror"));
		perl_info_print_table_row(2, replace, check_path("replace"));
		perl_info_print_table_row(2, which1, check_path("which1"));
		perl_info_print_table_row(2, zap, check_path("zap"));
		perl_info_print_table_end();
	}
}

1;
