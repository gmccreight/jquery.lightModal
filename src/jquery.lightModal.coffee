# LightModal is a a simple and lightweight lighbox/modal plugin. Made for use
# with inline content.
#
# Usage
# ==================
# $('.your-button').lightModal({
#  modalContainer: "#some_container"
# })

(($) ->
  methods =

    init: (options) ->
      @each ->
        $this = $(this)
        data = $this.data('lightModal')

        # use the href anchor as the id of the container
        if $this.attr('href')
          modalContainer = $this.attr('href')
        else
          modalContainer = '#some_container'

        @options = $.extend(
          modalContainer: modalContainer
          width: 'auto'
          closeButtonDisable: false
          padding: 36
          topMargin: 18
          overlayClickDismisses: true
          slideSpeed: 400
          overlayHtml: '<div class="lm-overlay"></div>'
          onShow: ->
            # Function that gets called on show
          onHide: ->
            # Function that gets called on hide
          $this.data('lightModal') or {},
          options or {}
        )

        unless data
          # data is empty, this is a new instance
          # Initialize the virgin plugin elements here

          # Init the modal element
          @$modalContainer = $(@options.modalContainer)
          @$modalContainer.hide()
          @$modalContainer.addClass('lm-modal-container')
          if @options.width != 'auto'
            @$modalContainer.width(@options.width)

          @modalContainerWidth = @$modalContainer.width()

          @$overlay = $(@options.overlayHtml)
          @$closeButton = $('<a>').text('Close').addClass('lm-close')

          #Bind a click listener to the element
          $this.click (e) ->
            e.preventDefault()
            $(this).lightModal('show')
    
    destroy: ->
      @each ->
        $this = $(this)
        data = $this.data 'lightModal'
        $(window).unbind '.lightModal'
        data.lightModal.remove()
        $this.removeData 'lightModal'

    # Show the modal box
    show: ->
      @each ->
        $this = $(this)

        # Set up the dimentions and position on the page
        @$modalContainer.width @modalContainerWidth - (@options.padding * 2)
        @$modalContainer.css 'left', ($(window).width() - @modalContainerWidth)/2 + 'px'
        @$modalContainer.css 'top', $(window).scrollTop() + @options.topMargin + 'px'
        @$modalContainer.css 'padding', @options.padding + 'px'

        # Add the close button
        unless @options.closeButtonDisable
          @$modalContainer.prepend @$closeButton
          @$closeButton.click (e) ->
            e.preventDefault()
            $this.lightModal('hide')

        # Add an overlay to the page
        @$overlay.appendTo('body').click (e) =>
          e.preventDefault()
          if @options.overlayClickDismisses
            $this.lightModal('hide')
        
        $(document).bind 'keyup.lightModal', (e) ->
          $this.lightModal('hide') if (e.keyCode == 27)

        @$modalContainer.slideDown(@options.slideSpeed)
        @options.onShow()
    
    # Hide/close the modal box
    hide: ->
      @each ->
        $this = $(this)
        @$modalContainer.slideUp(@options.slideSpeed)
        @$overlay.remove()
        @$closeButton.remove()
        $(document).unbind 'keyup.lightModal'
        @options.onHide()
  
  $.fn.lightModal = (method) ->
    if methods[method]
      methods[method].apply this, Array::slice.call(arguments, 1)
    else if typeof method == 'object' or not method
      methods.init.apply this, arguments
    else
      $.error 'Method ' + method + ' does not exist on jQuery.lightModal'
) jQuery
