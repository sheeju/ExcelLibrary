use strict;
use warnings;

use ExcelLibrary;

my $app = ExcelLibrary->apply_default_middlewares(ExcelLibrary->psgi_app);
$app;

