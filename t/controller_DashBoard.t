use strict;
use warnings;
use Test::More;


use Catalyst::Test 'ExcelLibrary';
use ExcelLibrary::Controller::DashBoard;

ok( request('/dashboard')->is_success, 'Request should succeed' );
done_testing();
