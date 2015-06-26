$(function () {
    // jQuery UI Draggable
    $(".dragable-zone .dragable-data").draggable({
        helper: "clone", opacity: "0.5",
        // brings the item back to its place when dragging is over
        //revert: true,
        //Bug fix: http://stackoverflow.com/questions/811037/jquery-draggable-and-overflow-issue
        appendTo: 'body',
        scroll: false,
        
        revert: function (event, ui) {
            $(this).css("border", "none");
            return !event;
        },
        start: function (e, ui) {
            //$(this).css("border", "2px solid blue");

            ui.helper.find('img').css("border", 'solid 2px yellow');

            //$('.bx-viewport').css('position', 'absolute');
            
            ui.helper.find('img').animate({
                    width: 50,
                    height: 50
            });
        },
        cursorAt: {left:50, top:25}
        // once the dragging starts, we decrease the opactiy of other items
        // Appending a class as we do that with CSS
        //drag: function () {
        //    $(this).addClass("active");
        //    $(this).closest(".dragable-zone").addClass("active");
        //},

        // removing the CSS classes once dragging is over.
        //stop: function () {
        //    $(this).removeClass("active").closest(".dragable-zone").removeClass("active");
        //}
    });

    // jQuery Ui Droppable
    $(".garden .pot").droppable({
        accept: ".dragable-data",

        // The class that will be appended to the to-be-dropped-element (basket)
        activeClass: "active",

        // The class that will be appended once we are hovering the to-be-dropped-element (basket)
        hoverClass: "dropHover",
        
        // The acceptance of the item once it touches the to-be-dropped-element basket
        // For different values http://api.jqueryui.com/droppable/#option-tolerance
        tolerance: "touch",
        drop: function (event, ui) {
            var pot = $(this),
                move = ui.draggable;

            //alert(move.attr('id'))
            //console.log('drop...' + pot.data('hovering'));

            pot.data('drag-item-id', move.attr('id'));
            
            //if (pot.data('hovering') == 'true')
            //    // Add the dragged item to the basket
            //    addToWindowBox(pot, move);
        }
    });
    
    $('.garden .pot')
      .mouseenter(function () {
          //$(this).data('hovering', 'true');
          var dragItemId = $(this).data('drag-item-id');
          addToWindowBox($(this), $('#' + dragItemId));
      })
      .mouseleave(function () {
          //$(this).attr('hovering', '');
      });
});

//var pot, move;

function addToWindowBox(pot, move) {
    var imgSrc = move.find("img").attr('src');
    var frameLeft = pot.attr('frame-left') + 'px';
    var frameTop = pot.attr('frame-top') + 'px';
    var frameRadius = pot.attr('frame-radius') + 'px';
    
    pot.find('img').remove();
    pot.append("<img src='" + imgSrc + "' style='width:" + frameRadius + ";min-height:"+frameRadius+";position: absolute;margin-left: " + frameLeft + ";margin-top:" + frameTop + "' >");
    
    //alert(pot.find('img').height())
}