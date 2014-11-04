use strict;
use warnings;
use Test::More;


use Catalyst::Test 'ExcelLibrary';
use ExcelLibrary::Controller::Userdashboard;

ok( request('/userdashboard')->is_success, 'Request should succeed' );
done_testing();
