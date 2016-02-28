# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

root = exports ? this

# Default dropzone options for mesh file uploads
root.dropzoneOpts =
  paramName: 'mesh[upload_attributes][file]'
  maxFiles: 1
  # addRemoveLinks: true
  previewTemplate: '
    <div class="file-row">
      <div>
        <p>
        <span class="name" data-dz-name></span>
        <span class="size pull-right" data-dz-size></span>
        </p>
        <strong class="error text-danger" data-dz-errormessage></strong>
      </div>
      <div>
        <div class="progress progress-striped active" role="progressbar" aria-valuemin="0" aria-valuemax="100" aria-valuenow="0">
          <div class="progress-bar progress-bar-success" style="width:0%;" data-dz-uploadprogress></div>
        </div>
        <button data-dz-remove class="btn btn-warning cancel">
            <i class="glyphicon glyphicon-ban-circle"></i>
            <span>Cancel</span>
        </button>
      </div>
    </div>
  '
  success: (file, response) ->
    $.getScript($(file.previewElement).parent().attr('action') + '.js')

# Disable auto discover for all elements
Dropzone.autoDiscover = false

jQuery ->
  # Initialize best_in_place
  $('.best_in_place').best_in_place()

  # Update datatable after inplace field changed
  $('.dataTable').on 'ajax:success', '.best_in_place', ->
    row = $(this).closest('tr')
    meshTable.row(row).invalidate()

  # Use a link to submit a form
  $('#submit_new_mesh').click ->
    $('#new_mesh').submit()

  # Programmatically define dropzones with personal options
  $('.dropzone').dropzone dropzoneOpts
