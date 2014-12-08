$(document).ready(function() {
	var table = $('#historyTable').dataTable();
	var numberofrecords =table.fnSettings().aoData.length;
	if(numberofrecords != 0)
	{
		var numberofcolumn = table.fnGetData(0).length;
		if(numberofcolumn == 8)
		{

			table.yadcf([{

				column_number: 1,filter_match_mode : "exact"
			}, {
				column_number: 2,filter_match_mode : "exact"
			}, {
				column_number: 7,filter_match_mode : "exact"
			}]);
		}
		else
		{
			table.yadcf([{

				column_number: 1,filter_match_mode : "exact"
			}, {
				column_number: 6,filter_match_mode : "exact"
			}]);

		}
	}
});
