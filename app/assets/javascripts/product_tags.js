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

  $(document).on('keypress', '.add-tag', function(e){
    if(e.which == 13) {
      tag = $(this).val()
      that = $(this)
      parent_id = $(this).data().parantId
      $.ajax({
        url: '/product_tags',
        method: 'POST',
        data: {
          product_tag: {
            name: tag,
            parent_id: parent_id
          }
        },
        beforeSend: function(xhr) {xhr.setRequestHeader('X-CSRF-Token', $('meta[name="csrf-token"]').attr('content'))},
        success: function(e) {
          $('input').val('')
          $(that).closest('.product-tags').append(e)
        }
      })
    }
  })


})