#= require jquery
#= require jquery_ujs
#= require turbolinks
#= require jquery_nested_form
#= require bootstrap-sprockets

error_message = (el, message) ->
  el.parents('.form-group').append("<div class='alert alert-danger'>" + message + "</div>")

phone_validation = (el) ->
  phone_match = /^\d+$/
  unless el.val().match(phone_match)
    error_message(el, "Wrong phone number format accept only digits")
    return false
  else
    return true

email_validation = (el) ->
  email_match = /^([\w-]+(?:\.[\w-]+)*)@((?:[\w-]+\.)*\w[\w-]{0,66})\.([a-z]{2,6}(?:\.[a-z]{2})?)$/i
  unless el.val().match(email_match)
    error_message(el, "Wrong email")
    return false
  else
    return true

blank_validation = (fields) ->
  if fields.phone.val().length <= 0 && fields.email.val().length <= 0
    for k, el of fields
      error_message(el, "One of these inputs can't be blank")
    return false
  else
    return true

init = ->
  setTimeout(->
    $('.alert').fadeOut()
  , 3000)

  share_contact = $('.share-contact form')

  share_contact.on 'ajax:error', ->
    alert 'Somthing wrong'
  share_contact.on 'ajax:success', ->
    $(this).parents('.share-contact').hide()
    alert 'Contact send'

  $('.send-on-email').on 'click', ->
    $(this).siblings('.share-contact').toggle()

  $('#new_contact').on 'submit', ->
    fields = {
      phone: $(this).find("input[name*=number]"),
      email: $(this).find("input[name*=email]")
    }

    $('.form-group').find('.alert').remove()

    if blank_validation(fields)
      if fields.phone.val().length > 0 then phone_validation(fields.phone)
      if fields.email.val().length > 0 then email_validation(fields.email)
    else
      return false

$(document).on('page:change', init)

# ie8 turbolinks fix
unless Turbolinks.supported
  $ init