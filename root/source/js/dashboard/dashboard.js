$(document).ready(function() {
    function DisableBackButton() {
        window.history.forward()
    }
    DisableBackButton();
    window.onload = DisableBackButton;
    window.onpageshow = function(evt) {
        if (evt.persisted) DisableBackButton()
    }
    window.onunload = function() {
        void(0)
    }

    $("#oldpassword").focus(function() {
        $('#passwordmessage').html('');
    });


    $.ajax({
        url: "dashboard/defaultsetting",
        success: function(data) {
            $('#noofdays').val(data.maxalloweddays);
            $('#noofbooks').val(data.maxallowedbooks);
        }
    });

    var curent;
    var element;
    if ($('#request').length) {
        $('#request').addClass("active");
        curent = '#request';
        element = '/request';
    } else {
        $('#book').addClass("active");
        curent = '#book';
        element = '/book';

    }
    loadpage(element);

    function loadpage(element) {
        $.ajax({
            url: element,
            contentType: 'text/html',
            dataType: 'html',
        }).done(function(responseText) {
            $("#content").html(responseText);
        }).fail(function(err) {
            alert("error" + err);
        });
    }
    $('.menu').click(function() {
        var id = $(this).attr('id');
        var path = "/" + id;
        id = '#' + id;
        $(curent).removeClass("active");
        $(id).addClass("active");
        curent = id;
        loadpage(path);
    });

    $('#configlib').click(function() {
        $("#settingform").validate({
            rules: {

                noofbooks: {
                    required: true,
                    number: true,
                    digits: true
                },
                noofdays: {
                    required: true,
                    number: true,
                    digits: true
                }
            },
            submitHandler: function(form) {
                var url = "/dashboard/dashboardConfig";
                var duration = $('#noofdays').val();
                var bookcount = $('#noofbooks').val();

                $.ajax({
                    type: "POST",
                    url: url,
                    data: {
                        noofbooks: bookcount,
                        noofdays: duration

                    },
                    success: function(data) {
                        $('#message').html(data.updatemessage);
                        var validator = $("#settingform").validate();
                        validator.resetForm();
                    }
                });
            }
        });

    });

    $('#changepassword').click(function() {
        $("#passwordform").validate({
            rules: {

                oldpassword: {
                    required: true,
                },
                newpassword: {
                    required: true,
					minlength: 6
                },
                confirmpassword: {
                    required: true,
					minlength: 6,
                    equalTo: "#newpassword"
                }
            },
            submitHandler: function(form) {
                var url = "/dashboard/changepassword";
                var oldpassword = $('#oldpassword').val();
                var newpassword = $('#newpassword').val();
                var confirmpassword = $('#confirmpassword').val();

                $.ajax({
                    type: "POST",
                    url: url,
                    data: {
                        oldpassword: oldpassword,
                        newpassword: newpassword

                    },
                    success: function(data) {
                        if (data.validmessage) {
                            $('#passwordmessage').html("Password Change Sucessfully");
                            $('#passwordform')[0].reset();
                            var validator = $("#passwordform").validate();
                            validator.resetForm();
                        } else {
                            $('#passwordmessage').html(data.invalidmessage);
                            $('#oldpassword').val('');
                        }

                    }
                });
            }
        });

    });

	$('#logoutbtn').click(function() {
		$.ajax({
			url: "login/logout",
			success: function(result) {}
		});

    });
});
