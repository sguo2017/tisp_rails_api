# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$(document).on 'turbolinks:load', ->
  $.post '/api/goods_catalogs/json', (data) ->
    container = undefined
    editor = undefined
    options = undefined
    container = document.getElementById('jsoneditor')
    if container
      options = mode: 'view'
      if $('#jsoneditor').length > 0
        $('#jsoneditor').empty()
      editor = new JSONEditor(container, options)
      editor.set data[0]
      editor.setName '所有分类'
    return
	
  # 捕捉下拉框事件
  $('#goods_catalog_parent_id').change ->
    select = $(this)[0]
    index = select.selectedIndex
    selected = $(select.options[index])
    $('#goods_catalog_level').val selected.data('level')+1
    return
	
  return
  

  

