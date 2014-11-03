#!/usr/bin/perl 

use FindBin;
use Getopt::Std;
use Data::Dumper;

use lib "$FindBin::Bin/../lib";

use DBIx::Class::Schema::Loader 'make_schema_at';

our ($opt_F, $opt_d);
getopts('Fd');

make_schema_at(
	'Schema',
	{
		debug                   => !!($opt_d),
		really_erase_my_files   => !!($opt_F),
		dump_directory          => "./lib/LibraryManagement/",
		overwrite_modifications => 1,
		preserve_case           => 1,
		naming                  => 'preserve',
	},
	['dbi:Pg:dbname=Library', 'pavan', '1234', {'quote_char' => '"', 'quote_field_names' => '0', 'name_sep' => '.'}],
);
