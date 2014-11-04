use strict;
use warnings;
use Test::More;


use Catalyst::Test 'ExcelLibrary';
use ExcelLibrary::Controller::AdminDashboard;

ok( request('/admindashboard')->is_success, 'Request should succeed' );
done_testing();
