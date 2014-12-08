$(document).ready(function() {
	$("#passwordchangeform").validate({
		rules: {
			email: {
				required: true,
				email: true
			}

		},
		submitHandler: function(form) {
			var email = $('#user_email').val();
			$.ajax({
				url: 'login/validate',
				data: {
					email: email,
				}
			}).done(function(data) {
				if (data.responsemessage) {
					$('#failmessage').html("Email is not registered");
					$('#user_email').val('');
				} else {
					$('#donemessage').html("Check your Email for change password");
					$('#user_email').val('');
				}
			});

		}
	});
	$('input').focus(function() {
		$('#failmessage').html("");
		$('#donemessage').html("");
	});

});
