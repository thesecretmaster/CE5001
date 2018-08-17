// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, or any plugin's
// vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file. JavaScript code in this file should be added after the last require_* statement.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require rails-ujs
//= require jquery
//= require jquery_ujs
//= require activestorage
//= require turbolinks
//= require_tree .

function setText() {
  messages = {'off': "Minimize comments once I've reviewed them",
  'on': "Stop minimizing comments once I've reviewed them"};
  ele = $(".toggle-minimize")[0];
  if (localStorage['ce5001MinimizeReviewed']) {
    ele.textContent = messages['on'];
  } else {
    ele.textContent = messages['off'];
  }
}

$( document ).ready(function() {
  setText();
  $('#settings').css('display', 'initial');
});

$(document).on('change', 'input[type=radio]', function (ev) {
  if (localStorage['ce5001MinimizeReviewed']) {
    $(ev.target).parents('.row').addClass('reviewed');
  }
});

$(document).on('click', '.toggle-minimize', function (ev) {
  ev.preventDefault();

  if (localStorage['ce5001MinimizeReviewed']) {
    localStorage.removeItem('ce5001MinimizeReviewed');
    $('.reviewed').removeClass('reviewed');
  }
  else {
    localStorage['ce5001MinimizeReviewed'] = 'true';
  }
  setText();

  var confirmer = $('<span class="text-success">&#x2713;</span>');
  confirmer.css({
    position: 'relative',
    top: '-0.5em'
  });
  $(ev.target).after(confirmer);
  confirmer.css('transition', 'all 0.5s ease');

  setTimeout(function () {
    confirmer.css({
      top: '-1.5em',
      filter: 'opacity(50%)'
    });
    setTimeout(function () {
      confirmer.remove();
    }, 500);
  }, 0);
});
