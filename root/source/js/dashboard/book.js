$(document).ready(function() {
	var oTable = $('#table').dataTable({
		"columnDefs": [{
			"targets": [5, 6],
			"orderable": false
		}],
	});

	var bookid;
	var count = 1;
	$('#table').delegate('.viewdetails', 'click', function() {
		bookid = $(this).attr('id');
		getbookcopy(bookid);
	});

	$('#table').delegate('.btn_comment', 'click', function() {
		bookid = $(this).attr('id');
		displaycomment(bookid);
	});

	function displaycomment(bookid) {
		$.ajax({
			url: 'dashboard/getcomments',
			data: {
				bookid: bookid,
			}
		}).done(function(data) {

			$('#div_comment').empty();
			if (data.flag) {
				$.each(data.comments, function(index, value) {
					var header = '<div class="panel panel-primary"><div class="panel-heading">';
					if (data.role == 'Admin') {
						header = header + '<button type="button" id="' + value.commentid + '" class="close btndltcomment"> &times;</button> <br>';
					}
					var elements = header + '<span>Commented By : ' + value.employeename + '</span>' + '<span class="text-right pull-right"> Date : ' + value.commentdate + '</span>' + '</div>' + '<div class = "panel-body">' + '<div class = "col-md-12 "><p class="txt-left">' + value.comment + ' </p></div>' + '</div>' + '</div>';
					$('#div_comment').prepend(elements);
				});
				$('.btndltcomment').click(function() {
					var commentid = $(this).attr('id');
					$.ajax({
						url: 'dashboard/deletecomment',
						data: {
							commentid: commentid,
						}
					}).done(function(data) {
						displaycomment(bookid);
					});
				});
			} else {
				$('#div_comment').append('<div class = "alert alert-info" role="alert" ><p class="txt-center"> No Previous Comments </p></div>');
			}

		}).fail(function(err) {
			alert("error" + err);
		});

	}
	    $('#btn_post').click(function() {
	        $("#commentform").validate({
	            rules: {
	                bookcomment: {
	                    required: true,
	                }

	            },
	            submitHandler: function(form) {
	                var comment = $('#txt_comment').val();

	                $.ajax({
	                    url: 'dashboard/addcomment',
	                    data: {
	                        bookid: bookid,
	                        comment: comment,
	                    }
	                }).done(function(responseText) {

	                    displaycomment(bookid);
	                    $('#txt_comment').val('');
	                });

	            }
	        });

	    });


	    var rowId;
	    $('#table').delegate('.rowClass', 'click', function() {
	        rowId = $(this).attr('id');
	    });


	    function getbookcopy(bookid) {
	        $('#detail_body').html('');
	        var detail_body;
	        count = 1;
	        $.ajax({
	            url: 'dashboard/copydetails',
	            contentType: 'text/html',
	            data: {
	                Id: bookid,
	            },
	        }).done(function(data) {
	            var btn;
	            $.each(data, function(index1, value1) {
	                $.each(value1, function(index, value) {
	                    if (value.button == 'delete') {
	                        btn = '<td>' +
	                            '<button type="button" id=' + value.id + ' class="btn btn-primary btn-sm dlt">' +
	                            '<span class="glyphicon glyphicon-trash"></span>' +
	                            '</button>' +
	                            '</td>'
	                    } else {
	                        btn = '<td>' +
	                            '<button type="button" id=' + value.id + ' class="btn btn-primary btn-sm disabled">' +
	                            '<span class="glyphicon glyphicon-lock"></span>' +
	                            '</button>' +
	                            '</td>'
	                    }
	                    detail_body += '<tr class="bookcopy ' + value.id + '">' +
	                        '<td>' + count + '</td>' +
	                        '<td>' + value.id + '</td>' +
	                        '<td>' + value.status + '</td>' +
	                        '<td>' + value.empname + '</td>' +
	                        '<td>' + value.issueddate + '</td>' +
	                        '<td>' + value.returndate + '</td>' + btn +
	                        '</tr>';
	                    count++;
	                });
	            });
	            $('#details_table').html(detail_body);
	            count = count - 1;
	            $('#Count_id').val(count);

	            $('.dlt').click(function() {
	                var buttonclicked = $(this);
	                var id = $(this).attr('id');
	                $.ajax({
	                    url: 'dashboard/deletecopy',
	                    contentType: 'text/html',
	                    data: {
	                        CopyId: id,
	                    }
	                }).done(function(data) {
	                    id = '.' + id;
	                    $(id).remove();
	                    count = count - 1;
	                    $('#Count_id').val(count);
	                    if (count < 1) {
	                        var page_number = oTable.fnPagingInfo().iPage;
	                        oTable.fnDeleteRow('#' + rowId, function() {
	                            oTable.fnPageChange(page_number);
	                        }, false);
							 $('#detailsModal').modal('hide');
	                    }
	                }).fail(function(err) {
	                    alert("error" + err);
	                });
	            });
	        });
	    }


	    $('.addCopies').click(function() {
	        count = count + 1;
	        $('#Count_id').val(count);
	        $.ajax({
	            url: 'dashboard/addcopies',
	            data: {
	                bookId: bookid,
	                Count: count,
	            }
	        }).done(function(responseText) {
	            getbookcopy(bookid);
	        });

	    });

	    $('#addbook').click(function() {
	        $("#book_insertion").validate({
	            rules: {
	                bookname: {
	                    required: true,
	                    alphanumeric: true
	                },
	                booktype: {
	                    required: true,
	                    lettersonly: true

	                },
	                author: {
	                    required: true,
	                    lettersonly: true

	                },
	                noofcopies: {

	                    number: true,
	                    digits: true,
	                    required: true
	                }
	            },
	            submitHandler: function(form) {
	                var url = "/dashboard/addbook";
	                var name = $('#bookname').val();
	                var author = $('#author').val();
	                var type = $('#booktype').val();
	                var noOfCopies = $('#noofcopies').val();
	                $.ajax({
	                    type: "POST",
	                    url: url,
	                    data: {
	                        name: name,
	                        author: author,
	                        type: type,
	                        count: noOfCopies,

	                    },
	                    success: function(data) {
	                        $('#sucess_message').html(data.message);
	                        $('#book_insertion')[0].reset();
	                        var validator = $("#book_insertion").validate();
	                        validator.resetForm();

	                    }
	                });
	            }
	        });
	        $('#myModal').on('hide.bs.modal', function() {
	            $.ajax({
	                url: '/book',
	                type: 'POST',

	            }).done(function(data) {
	                $(".modal-backdrop").hide();
	                $('#content').html(data);
	                $('.addbookalert').removeClass('hidden');
	            });
	        });
	    });

	    $("input").focus(function() {
	        $('#sucess_message').html('');
	    });

	    $(".close").click(function() {
	        $('.alert').addClass('hidden');
	    });

		$('#table').delegate('.book_req', 'click', function() {
			var bookid = $(this).attr('id');
			$.ajax({
				url: "/dashboard/bookrequest",
				data: {
					bookId: bookid,
				},
				success: function(data) {
					if (data.deniedflag) {
						$('.maxbook').removeClass('hidden');

					} else {
						id = '#' + bookid;
						var msg = '#lbl' + bookid;
						$(id).addClass('hidden');
						$(msg).removeClass('hidden');
					}
				}
			});
		});

	});
