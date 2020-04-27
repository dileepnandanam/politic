$(document).on('turbolinks:load', function() {

  $(document).on('ajax:success', '.product-tag', function(e) {
    $(this).closest('.product-tags').nextAll().remove()
    $(this).closest('.prodict-tags-container').append(e.detail[2].responseText)
    $(this).siblings('.products').remove()  
  })


  search = function() {
    query = $('.search-tags').val()
    $.ajax({
      url: '/b2b/product_tags',
      data: {
        query: query
      },
      success: function(data) {
        $('.prodict-tags-container').html(data)
      }
    })
  }

  $('.search-tags').keyup($.debounce(1250, search))

  bind_add_tag = function() {
    $(document).on('keypress', '.add-tag', function(e){
      $(document).off('keypress', '.add-tag')
      if(e.which == 13) {
        tag = $(this).val()
        that = $(this)
        parent_id = $(this).data().parantId
        $.ajax({
          url: '/b2b/product_tags',
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
      bind_add_tag()
    })
  }
  bind_add_tag()

  $(document).on('ajax:success', '.new-product-link', function(e) {
    $(this).siblings('.new-product-form').html(e.detail[2].responseText)
  })
  $(document).on('ajax:success', 'form.new_product', function(e) {
    $(this).closest('.new-product-form').siblings('.products').append(e.detail[2].responseText)
    $(this).remove()
  })
  $(document).on('ajax:error','form.new_product', function(e) {
    $(this).replaceWith(e.detail[2].responseText)
  })


  $(document).on('ajax:success', '.product', function(e) {
    $('.product-container').html(e.detail[2].responseText)
  })

  $(document).on('ajax:success', '.edit-product-link', function(e) {
    $(this).siblings('.edit-product').html(e.detail[2].responseText)
  })

  $(document).on('ajax:success', 'form.edit_product', function(e) {
    $(this).closest('.product').replaceWith(e.detail[2].responseText)
  })
  $(document).on('ajax:error', 'form.edit_product', function(e) {
    $(this).replaceWith(e.detail[2].responseText)
  })

  $(document).on('ajax:success', '.delete-product-link', function(e) {
    $(this).closest('.product').remove()
  })

})