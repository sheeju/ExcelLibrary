$(document).ready(function() {
    var index = 0;

    $('#detail_div').addClass("hidden");
    $('#msg').addClass("hidden");
    $('#cmb_searchby').change(function() {
        $('#detail_div').addClass("hidden");
        index = $('option:selected', $('#cmb_searchby')).index();
        if (index == 1) {
            $('#spn_txt').text("Employee ID");
        } else {
            $('#spn_txt').text("Book Copy ID");
        }
    });

    $('#btn_check').click(function() {

        if (index == 0) {
            gettransactionbycopyid();
        } else {
            gettransactionbyemployeeid();
        }
    });


    function gettransactionbycopyid() {
        var copy_id = $('#txt_id').val();
        var regex = /^[1-9]+$/;
        if (regex.test(copy_id)) {
            $.ajax({
                url: 'dashboard/gettransactionbycopyid',
                contentType: 'text/html',
                dataType: 'json',
                data: {
                    copy_id: copy_id
                }

            }).done(function(data) {
                if (data.flag) {
                    $('#tbl_row_cpyadded').remove();
                    $('#msg').addClass("hidden");
                    $('#detail_div').removeClass("hidden");
                    $('#tbl_detail_employeeid').addClass("hidden");
                    $('#tbl_detail_copyid').removeClass("hidden");
                    $('#tbl_detail_copyid').append('<tr id="tbl_row_cpyadded"><td>' + data.id + '</td>' +
                        '<td>' + data.empname + '</td>' +
                        '<td>' + data.bookname + '</td>' +
                        '<td>' + data.issuedate + '</td>' +
                        '<td>' + data.expreturndate + '</td>' +
                        '</tr>');
                } else {
                    $('#detail_div').addClass("hidden");
                    $('#msg').removeClass("hidden");
                    $('#msg').text('No Book Issued For This ID');

                }
            }).fail(function(err) {
                alert("error" + err);
            });
        } else {
            $('#msg').removeClass("hidden");
            $('#detail_div').addClass("hidden");
            $('#msg').text('Invalid input enter book copy id');

        }
    };

    function gettransactionbyemployeeid() {
        var emp_id = $('#txt_id').val();
        var regex = /^[1-9]+$/;
        if (regex.test(emp_id)) {
            $.ajax({
                url: 'dashboard/gettransactionbyemployeeid',
                contentType: 'text/html',
                dataType: 'json',
                data: {
                    emp_id: emp_id
                }
            }).done(function(data) {
                if (data.flag) {
                    $('.tbl_row_empadded').remove();
                    $('#msg').addClass("hidden");
                    $('#detail_div').removeClass("hidden");
                    $('#tbl_detail_employeeid').removeClass("hidden");
                    $('#tbl_detail_copyid').addClass("hidden");
                    $.each(data.booktaken, function(index, value) {
                        $('#tbl_detail_employeeid').append('<tr class="tbl_row_empadded"><td>' + value.bookcopyid + '</td>' +
                            '<td>' + value.bookname + '</td>' +
                            '<td>' + value.issuedate + '</td>' +
                            '<td>' + value.expreturndate + '</td>' +
                            '<td> <input type="checkbox" name="bookcopyid" class="chk_bookreturn" value="' + value.bookcopyid + '" /></td>' +
                            '</tr>');
                    });

                    $('#msg').removeClass("hidden");
                    $('#msg').text("Employee Name  : " + data.employeename);
                } else {
                    $('#detail_div').addClass("hidden");
                    $('#msg').removeClass("hidden");
                    $('#msg').text('No Book Issued For ID');

                }
            }).fail(function(err) {
                alert("error" + err);
            });
        } else {
            $('#msg').removeClass("hidden");
            $('#detail_div').addClass("hidden");
            $('#msg').text('Invalid input enter employee id');
        }
    };


    $('#btn_return').click(function() {
        var comment = $('#comment').val();
        var copy_id = new Array;
        if (index == 1) {

            $('.chk_bookreturn:checked').each(function() {
                copy_id.push($(this).val());
            });
        } else {
            copy_id.push($('#txt_copy_id').val());
        }

        if (copy_id.length > 0) {

            $.ajax({
                url: 'dashboard/returnbook',
                contentType: 'text/html',
                dataType: 'json',
                data: {
                    copy_id: copy_id,
                    comment: comment
                }
            }).done(function(data) {
                if (data.result) {
                    $('#msg').removeClass("hidden");
                    $('#detail_div').addClass("hidden");
                    $('#msg').text('Book(s) Marked As Returned');
                }
            }).fail(function(err) {
                alert("error" + err);
            });
        } else {
            $('#msg').removeClass("hidden");
            $('#msg').text('Select the book want to return');
        }
    });

    $.validator.setDefaults({
        errorPlacement: function(error, element) {
            error.appendTo('#nameError');
        }
    });

    $("#book_return").validate({
        rules: {
            text_id: {
                required: true,
                number: true,
                digits: true

            }

        },
        submitHandler: function(form) {

            //				$('#text_id').val('');
        }

    });


});
