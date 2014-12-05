$(document).ready(function() {

    $("#passwordform").validate({
        rules: {
            password: {
                required: true,
                minlength: 6
            },
            retype: {
                required: true,
                equalTo: "#txt_password"
            }
        },
        submitHandler: function(form) {
            var token = $('#txt_token').val();
            var password = $('#txt_password').val();
            $.ajax({
                url: 'login/createpassword',
                contentType: 'text/html',
                dataType: 'html',
                data: {
                    password: password,
                    token: token
                }
            }).done(function(responseText) {
                form.submit();
            }).fail(function(err) {
                alert("error" + err);
            });

        }
    });
});
