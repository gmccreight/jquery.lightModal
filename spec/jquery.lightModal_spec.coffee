path = ''
if typeof(window.__karma__) != 'undefined'
  path += 'base/'

jasmine.getFixtures().fixturesPath = path + 'spec/fixtures'

describe "Light Modal box plugin", ->

  beforeEach ->
    loadFixtures "modals.html"
    $("#modal_trigger_1").lightModal({slideSpeed:100})
    $("#modal_trigger_2").lightModal
      onShow: ->
        $('#modal2_status').text('showing')
      onHide: ->
        $('#modal2_status').text('hidden')
  
  describe "Initialisation", ->

    it "should hide the modal", ->
      expect($("#modal_1")).toBeHidden()
      expect($("#modal_2")).toBeHidden()
    
    it "should add a 'lm-modal' class to the modal box", ->
      expect($("#modal_1")).toHaveClass "lm-modal"
      expect($("#modal_2")).toHaveClass "lm-modal"

  describe "Showing", ->

    beforeEach ->
      $("#modal_trigger_1").lightModal 'show'
      $('.lm-modal').stop()

    afterEach ->
      $("#modal_trigger_1").lightModal 'hide'
      
    it "should show the modal", ->
      expect($("#modal_1")).toBeVisible()
      expect($("#modal_2")).toBeHidden()
    
    it "should have an overlay", ->
      expect($(".lm-overlay")).toBeVisible()
      expect($(".lm-overlay").size()).toEqual(1)

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
      $('.lm-modal').stop()

    it "should hide the modal", ->
      waits 200
      runs ->
        expect($("#modal_1")).toBeHidden()
    
    it "should hide the overlay", ->
      expect($(".lm-overlay").size()).toEqual(0)

    it "should execute the onHide function", ->
      expect($('#modal2_status').text()).toEqual('hidden')

    it "should hide the modal and overlay when the overlay is clicked", ->
      $("#modal_trigger_1").lightModal 'show'
      waits 200
      runs ->
        $(".lm-overlay").click()
        waits 200
        runs ->
          expect($("#modal_1")).toBeHidden()
          expect($(".lm-overlay").size()).toEqual(0)

    it "should not hide if overlay click should not dismiss", ->
      $("#modal_trigger_1").lightModal({overlayClickDismisses:false})
      $("#modal_trigger_1").lightModal 'show'
      waits 200
      runs ->
        $(".lm-overlay").click()
        waits 200
        runs ->
          expect($("#modal_1")).toBeVisible()
          expect($(".lm-overlay").size()).toEqual(1)
