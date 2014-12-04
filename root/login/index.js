		$(document).ready(function() {
				$("#loginform").validate({
					rules: {
						email: {
							required: true,
							email: true
						},
						password: {
							required: true,
							minlength:6
						}
					},
					submitHandler: function(form) {
						form.submit();

					}
				});


				$( "input" ).focus(function() {
					$('#resdata').hide();
				});

			});

