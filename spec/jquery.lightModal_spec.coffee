describe "Light Modal box plugin", ->
  putOptionValuesIntoArray = ($options, getText) ->
    values = []
    if getText == true
      $options.each ->
        values.push $(this).text()
    else
      $options.each ->
        values.push $(this).val()
    values

  path = ''
  if typeof(window.__karma__) != 'undefined'
    path += 'base/'

  jasmine.getFixtures().fixturesPath = path + 'spec/fixtures'

  beforeEach ->
    loadFixtures "modals.html"
    $("#modal_trigger_1").lightModal()
    $("#modal_trigger_2").lightModal
      onShow: ->
        $('#modal2_status').text('showing')
      onHide: ->
        $('#modal2_status').text('hidden')
  
  describe "Initialisation", ->
    it "should hide the modal", ->
      expect($("#modal_1")).toBeHidden()
      expect($("#modal_2")).toBeHidden()
    
    it "should add a 'modal' class to the modal box", ->
      expect($("#modal_1")).toHaveClass "modal"
      expect($("#modal_2")).toHaveClass "modal"

  describe "Showing", ->
    beforeEach ->
      $("#modal_trigger_1").lightModal 'show'
      $('.modal').stop()

    afterEach ->
      $("#modal_trigger_1").lightModal 'hide'
      
    it "should show the modal", ->
      expect($("#modal_1")).toBeVisible()
      expect($("#modal_2")).toBeHidden()
    
    it "should have an overlay", ->
      expect($(".light-modal-overlay")).toBeVisible()
      expect($(".light-modal-overlay").size()).toEqual(1)

    it "should execute the onShow function", ->
      $("#modal_trigger_2").lightModal 'show'
      expect($('#modal2_status').text()).toEqual('showing')
      $("#modal_trigger_2").lightModal 'hide'

  describe "Hiding", ->
    beforeEach ->
      $("#modal_trigger_1").lightModal 'show'
      $("#modal_trigger_1").lightModal 'hide'
      $("#modal_trigger_2").lightModal 'show'
      $("#modal_trigger_2").lightModal 'hide'
      $('.modal').stop()

    it "should hide the modal", ->
      waits 500
      runs ->
        expect($("#modal_1")).toBeHidden()
    
    it "should hide the overlay", ->
      expect($(".light-modal-overlay").size()).toEqual(0)

    it "should execute the onHide function", ->
      expect($('#modal2_status').text()).toEqual('hidden')

    # it "should hide the modal and overlay when the overlay is clicked", ->
    #   $("#modal_trigger_1").lightModal 'show'
    #   $(".light-modal-overlay").click()
    #   waits 500
    #   runs ->
    #     expect($("#modal_1")).toBeHidden()
    #     expect($(".light-modal-overlay").size()).toEqual(0)
