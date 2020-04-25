$(document).on('turbolinks:load', function() {

  $(document).on('ajax:success', '.product-tag', function(e) {
    $(this).closest('.product-tags').nextAll().remove()
    $(this).closest('.prodict-tags-container').append(e.detail[2].responseText)
  })


  search = function() {
    query = $('.search-tags').val()
    $.ajax({
      url: '/product_tags',
      data: {
        query: query
      },
      success: function(data) {
        $('.prodict-tags-container').html(data)
      }
    })
  }
  $('.search-tags').keyup($.debounce(1250, search))

})