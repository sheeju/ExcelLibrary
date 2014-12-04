$(document).ready(function() {
    var table = $('#historyTable').dataTable().yadcf([{
        column_number: 1
    }, {
        column_number: 2
    }, {
        column_number: 7
    }]);

    $.ajax({
        url: '/history',
    });
});
