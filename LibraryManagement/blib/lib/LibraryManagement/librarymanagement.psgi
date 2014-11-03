use strict;
use warnings;

use LibraryManagement;

my $app = LibraryManagement->apply_default_middlewares(LibraryManagement->psgi_app);
$app;

