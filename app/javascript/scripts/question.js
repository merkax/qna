document.addEventListener('turbolinks:load', function () {
    $('.question').on('click', '.edit-question-link', function (event) {
    event.preventDefault();
    $(this).hide();
    $('form#edit-question').removeClass('hidden');
  })
});

