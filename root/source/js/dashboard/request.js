$(document).ready(function() {
    var req_id;
    $('#request_table').DataTable({
        "columnDefs": [{
            "targets": 4,
            "orderable": false
        }]

    });

    $('#request_table').delegate('.req_allow', 'click', function() {
        var id = $(this).attr('id');
        $.ajax({
            url: 'dashboard/managerequest',
            contentType: 'text/html',
            dataType: 'html',
            data: {
                id: id,
                response: 'Allow'
            }
        }).done(function(responseText) {
            $("#content").html(responseText);
        }).fail(function(err) {
            alert("error" + err);
        });

    });

    $('#request_table').delegate('.req_deny', 'click', function() {
        req_id = $(this).attr('id');
    });

    $('#btn_deny').click(function() {
        var reason = $('#txt_denyreason').val();

        $("#denyform").validate({
            rules: {
                txt_denyreason: {
                    required: true,
                }
            },
            submitHandler: function(form) {

                $.ajax({
                    url: 'dashboard/managerequest',
                    contentType: 'text/html',
                    data: {
                        id: req_id,
                        response: 'Denied',
                        reason: reason
                    }
                }).done(function(responseText) {

                    $(".modal-backdrop").hide();
                    $("#content").html(responseText);
                });
            }
        });





    });

    $('#request_table').delegate('.book_issue', 'click', function() {
        req_id = $(this).attr('id');
        $('#cmb_booklist').empty();
        $('#div_model_msg').addClass('hidden');
        $('#div_model_cmb').removeClass('hidden');
        $.ajax({
            url: 'dashboard/getbookcopies',
            contentType: 'text/html',
            dataType: 'json',
            data: {
                req_id: req_id
            }
        }).done(function(data) {
            if (typeof data.books != 'undefined') {

                $.each(data.books, function(index, value) {
                    $('#cmb_booklist').append('<option>' + value + '</option>');
                });
            } else {
                $('#div_model_msg').removeClass('hidden');
                $('#div_model_cmb').addClass('hidden');
            }
        }).fail(function(err) {
            alert("error in getbook" + err);
        });

    });

    $('#btn_issue').click(function() {
        var bc_id = $('#cmb_booklist').val();
        $.ajax({
            url: 'dashboard/issuebook',
            contentType: 'text/html',
            dataType: 'html',
            data: {
                req_id: req_id,
                bc_id: bc_id
            }
        }).done(function(data) {
            $("#content").html(data);
            $(".modal-backdrop").hide();

        }).fail(function(err) {
            alert("error in getbook" + err);
        });

    });


	$('#denyModal').on('hide.bs.modal', function() {
		$(".modal-backdrop").hide();
		$('#txt_denyreason').text('');
		var validator = $("#denyform").validate();
		validator.resetForm();
	});


});
