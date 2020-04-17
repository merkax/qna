document.addEventListener('turbolinks:load', function() {
  $('.vote').on('ajax:success', function(event) {

    var name = event.detail[0]['name']
    var id = event.detail[0]['id']
    var rating = event.detail[0]['rating']

    $('.' + name + '_' + id + ' .vote .rating').html(rating)
  })
});
