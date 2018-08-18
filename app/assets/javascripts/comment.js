// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.

function setText() {
  const messages = {'off': "Minimize comments once I've reviewed them",
  'on': "Stop minimizing comments once I've reviewed them"};
  const ele = $(".toggle-minimize")[0];
  if (ele != undefined) {
    if (localStorage['ce5001MinimizeReviewed']) {
      ele.textContent = messages['on'];
    } else {
      ele.textContent = messages['off'];
    }
  }
}

$( document ).ready(function() {
  setText();
  $('.dropdown-noscript').removeClass('dropdown-noscript');
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
