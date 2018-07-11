// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.

$(document).on('ajax:success', 'form.button_to', function(e, data) {
  var data = e.detail[0];
  if (data.status == 'success') {
    var div = document.createElement('div');
    div.className = 'alert alert-success alert-dismissible';
    div.innerHTML = '<button type="button" class="close" data-dismiss="alert" aria-label="Close"><span aria-hidden="true">&times;</span></button>'+"Database dump task has been queued";
    $("#alerts").append(div);
  } else {
    var div = document.createElement('div');
    div.className = 'alert alert-danger alert-dismissible';
    div.innerHTML = '<button type="button" class="close" data-dismiss="alert" aria-label="Close"><span aria-hidden="true">&times;</span></button>'+"Something went wrong... Ask an admin!";
    $("#alerts").append(div);
  }
});
