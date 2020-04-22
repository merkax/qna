//$(document).on('turbolinks:load', function () {
document.addEventListener('turbolinks:load', function () {

  $('form.new-comment').on('ajax:success', function (event) {
    var body = event.detail[0]['body'];
    var type = event.detail[0]['commentable_type'].toLowerCase();
    var resourceId = event.detail[0]['commentable_id'];

    $('textarea').val('');
    
    $(`.${type}_${resourceId} .comments`).append('<div class="comment"><p>' +
    body + '</p></div>');
  })
    .on('ajax:error', function (event) {
      var errors = event.detail[0];

      $.each(errors, function (index, value) {
        $('.comment-errors').html('');
        $('.comment-errors').append('<p>' + value + '</p>');
      })
    })
});
