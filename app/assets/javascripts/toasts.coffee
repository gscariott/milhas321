document.addEventListener 'turbolinks:load', ->
  document.querySelectorAll('.toast').forEach (toastTarget) ->
    new bootstrap.Toast(toastTarget).show()