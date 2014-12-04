$(document).ready(function() {
    $('#user_table').DataTable({
        "columnDefs": [{
            "targets": [5, 6],
            "orderable": false
        }]
    });
    $("#form_adduser").validate({

        rules: {
            empname: {
                required: true,
                lettersonly: true
            },
            empmail: {
                required: true,
                email: true
            },
        },
        submitHandler: function(form) {
            var url = "dashboard/adduser";
            var name = $('#txt_empname').val();
            var role = $('#cmb_role').val();
            var email = $('#txt_empemail').val();
            $.ajax({
                type: "POST",
                url: url,
                data: {
                    name: name,
                    role: role,
                    email: email
                },

            }).done(function(data) {
                $('#sucess_message').html(data.message);
                $('#form_adduser')[0].reset();
                var validator = $("#form_adduser").validate();
                validator.resetForm();
            });
        }
    });
    $('#myModal').on('hide.bs.modal', function() {
        $.ajax({
            url: '/user',
            type: 'POST',

        }).done(function(data) {

            $(".modal-backdrop").hide();
            $('#content').html(data);
            $('.alert').removeClass('hidden');
        });
    });

    $('.deleteuser').click(function() {
        user_id = $(this).attr('id');
        $.ajax({
            url: 'dashboard/deleteuser',
            contentType: 'text/html',
            data: {
                userid: user_id
            }
        }).done(function(data) {
            $('#content').html(data);

        });
    });
    $('.empupdate').click(function() {
        var empid = $(this).attr('id');
        var emprole = $(this).attr('name');
        $("#emprole").val(emprole);
        $('#updaterole').click(function() {
            updaterole = $("#emprole").val();
            $.ajax({
                url: 'dashboard/updaterole',
                contentType: 'text/html',
                data: {
                    empid: empid,
                    emprole: updaterole
                }
            }).done(function(data) {
                $(".modal-backdrop").hide();
                $('#content').html(data);
            });

        });
    });
    $(".close").click(function() {
        $('.alert').addClass('hidden');
    });


});
