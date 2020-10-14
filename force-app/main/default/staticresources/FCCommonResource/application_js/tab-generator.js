$(document).tooltip({
    position: {
        my: "center bottom-20",
        at: "center bottom",
        using: function (position, feedback) {
            $(this).css(position);
            $("<div id='tooltip'>")
            .addClass("arrow")
              .addClass(feedback.vertical)
              .addClass(feedback.horizontal)
              .appendTo(this);
        }
    }
});

function setApexpStyleClass() {
    $('.apexp').addClass('apexp_dashboard');
}
function hideDialog() {                            
    $(jQuery('[id$=confirmDialog]')[0]).hide();
}
function resetTabsList() {             
    $('.ddlExistingRecords').find('a span:first-child').text($('.ddlExistingRecords option:eq(0)').text())
    $('.ddlExistingRecords option:eq(0)').attr('selected', true);
}

function initialize() {
    $('.apexp').each(
      function () {
          $(this).addClass('apexp_dashboard');
      }
    );
}


function initializeForm() {
    try {
        $('.ddlExistingRecords').select2({
            minimumResultsForSearch: -1
        });
    }
    catch (ex) {}

    try {
        $('.tabOptions').select2({
            minimumResultsForSearch: -1
        });
    }
    catch (ex) {}

    try {
        $('.AssociatetabOptions').select2({
            minimumResultsForSearch: -1
        });
    }
    catch (ex) { }

    setApexpStyleClass();
}

function initializetinymce() {
    if (tinymce.editors.length > 0) {
        for (i = 0; i < tinymce.editors.length; i++) {
            tinyMCE.editors[i].setContent($(tinyMCE.editors[0].getElement()).val());
            tinyMCE.editors[i].destroy();
        }
    }
    tinymce.init({
        selector: 'textarea.txtinstruction',
        menubar: false,
        plugins: "textcolor,fullscreen",
        toolbar: ["undo redo | ,styleselect,formatselect,fontselect,fontsizeselect  | bold italic | alignleft aligncenter alignright alignjustify | fullscreen | forecolor backcolor | bullist numlist"]
    });
}
function saveTabRecord() {
    if (tinymce.editors.length > 0) {
        for (i = 0; i < tinymce.editors.length; i++) {
            tinyMCE.editors[i].save();
        }
    }
    saveRelatedListControllerRecord();
}

function initializeSelect() {
    try {
        $('.select').select2({
            minimumResultsForSearch: -1
        });
    }
    catch (ex) { }

    try {
        $('.searchSelect').select2();
    }
    catch (ex) { }
}