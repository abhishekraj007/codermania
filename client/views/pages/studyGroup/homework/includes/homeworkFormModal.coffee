processForm = (form) ->
  data = $(form).serializeJSON()
  data.points = parseInt(data.points) || 0
  data.description = $('#homework-description-textarea').summernote().code()
  if Router.current().route.getName() == 'studyGroup'
    studyGroupId = Router.current().params._id
  else
    studyGroupId = Router.current().params.studyGroupId
  console.log data, studyGroupId
  if data._id
    Meteor.call 'updateHomework', data, (err, result) ->
      if err
        bootbox.alert err.reason
        console.log err
      else
        $('#homework-form-modal').modal('hide')
  else
    delete data._id #we can't have empty _id for creating homework
    console.log 'creating homework for study group: ', studyGroupId
    Meteor.call 'createHomework', data, studyGroupId, (err, result) ->
      if err
        bootbox.alert err.reason
        console.log err
      else
        $('#homework-form-modal').modal('hide')

Template.homeworkFormModal.onRendered ->
  summernote = @$('#homework-description-textarea').summernote()
  if @data?.homework?.description
    summernote.code(@data.homework?.description)
  if @data?.description
    summernote.code(@data?.description)

Template.homeworkFormModal.events
  'submit #homework-form': (evt, tpl) ->
    evt.preventDefault()
    processForm(document.getElementById('homework-form'))
  'click #homework-form-submit-btn': (evt) ->
    processForm(document.getElementById('homework-form'))
