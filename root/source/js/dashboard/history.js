$(document).ready(function() {
	var table = $('#historyTable').dataTable();
	var numberofcolumn =table.fnGetData(0).length;
	if(numberofcolumn == 8)
	{

		table.yadcf([{

			column_number: 1
		}, {
			column_number: 2
		}, {
			column_number: 7
		}]);
	}
	else
	{
		table.yadcf([{

			column_number: 1
		}, {
			column_number: 2
		}, {
			column_number: 5
		}]);

	}

});
