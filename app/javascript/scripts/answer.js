document.addEventListener('turbolinks:load', function () {
  $('.answers').on('click', '.edit-answer-link', function (event) {
    event.preventDefault();
    $(this).hide();
    var answerId = $(this).data('answerId');
    $('form#edit-answer-' + answerId).removeClass('hidden')
  })
});

