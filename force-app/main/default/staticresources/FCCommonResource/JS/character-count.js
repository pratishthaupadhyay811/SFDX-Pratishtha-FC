var arrckeditor = [];
var defaultLimit = 40;
var defaultFormat = '<div id="cke_charcount_div" style="text-align:right;margin-top: 2px;margin-bottom: 2px;font-style: italic;"> <span class="cke_charcount_count">%count%</span> ' + window.counterOf + ' <span class="cke_charcount_limit">%limit%</span> ' + window.counterCharacters + ' </div>';
var limit = defaultLimit;
var format = defaultFormat;
var charactercounterdiv;
var fieldshash = {};
var longfieldshash = {};
var count;
var maxLength;
var length;
$(document).ready(function () {
    setCharCountForTextArea();
    /*  if (typeof CKEDITOR != "undefined")
          setCharCountForCkEditor();*/
});

function setCharCountForCkEditor() {
    var obj;
    for (var i in CKEDITOR.instances)
        arrckeditor.push(CKEDITOR.instances[i].name);
    if (theControllerValue != '' && theControllerValue != 'undefined') {
        obj = $.parseJSON(theControllerValue);
        for (var key in obj.rich) {
            for (var i = 0; i < arrckeditor.length; i++)
                if (arrckeditor[i].indexOf(key) >= 0) {
                    fieldshash[arrckeditor[i]] = obj.rich[key];
                    break;
                }
        }
        for (var i in CKEDITOR.instances) {
            (function (i) {
                CKEDITOR.instances[i].on('key', function (event) {
                    getCharacterCountDiv(CKEDITOR.instances[i], fieldshash[CKEDITOR.instances[i].name]);
                });

                CKEDITOR.instances[i].on('instanceReady', function (event) {
                    getCharacterCountDiv(CKEDITOR.instances[i], fieldshash[CKEDITOR.instances[i].name]);
                });

                //CKEDITOR.instances[i].on('paste', function (event) {
                //    window.setTimeout(function (editor) {
                //        getCharacterCountDiv(CKEDITOR.instances[i], fieldshash[CKEDITOR.instances[i].name]);
                //    }, 500, event.editor);
                //});
                CKEDITOR.instances[i].on('blur', function (event) {
                    getCharacterCountDiv(CKEDITOR.instances[i], fieldshash[CKEDITOR.instances[i].name]);
                });

            })(i);
        }
    }


}

function setCharCountForTextArea() {

    $('textarea').keydown(function (e) {
        if (!e.ctrlKey && ([90, 89, 88, 86, 65, 66].indexOf(e.which) == -1)) {
            if ((((count + 1) == maxLength) && e.which == 13) || ((count >= maxLength) && e.which != 8 && e.which != 46 && e.which != 37 && e.which != 38 && e.which != 39 && e.which != 40)) {
                e.preventDefault();
            }
        }
    });

    $('textarea').keyup(function (e) {
        displayCharCountForLongText(this);
    });

    $('textarea').on('paste', function (e) {
        var objTextbox = this;
        setTimeout(function () {
            displayCharCountForLongText(objTextbox);
        }, 100);
    });
    for (var i = 0; i < $('textarea').length; i++) {
        displayCharCountForLongText($('textarea')[i]);
    }
}

function strTrim(objTextbox) {
    var str = objTextbox.value.substring(length - (count - maxLength), maxLength);
    var entersInStr = 0;
    for (var j = 0; j < str.length; j++) {
        if (str.charAt(j) == '\n')
            entersInStr++;
    }
    objTextbox.value = objTextbox.value.substring(0, length - (count - maxLength) + Math.floor(entersInStr / 2));
}

function getCharacterCountDiv(editor, limit) {
    try {
        updateCount(editor, limit);
        getTextFromHTML(loadXMLString(editor.getData()), editor, limit);
        updateCount(editor, limit);
    } catch (err) {
        editor.setData("");
        updateCount(editor, limit);
    }
}

function updateCount(editor, limit) {
    this.limit = limit;
    var data = editor.getData();
    var brlength = data.split("<br />");
    var lilength = 0;
    if (data.split("</li>").length > 1) {
        lilength = data.split("</li>").length + 2;
    }
    count = data.length + (brlength.length - 1) + lilength;
    var divid = 'charcount_div_' + editor.name;
    charactercounterdiv = '<div id="' + divid + '" style="text-align:right;margin-top: 2px;margin-bottom:2px;font-style: italic;"> <span class="cke_charcount_count">%count%</span> ' + window.counterOf + ' <span class="cke_charcount_limit">%limit%</span> ' + window.counterCharacters + ' </div>';
    var html = charactercounterdiv.replace('%count%', count).replace('%limit%', limit);
    $(document.getElementById(divid)).remove()
    $(counterElement(editor)).after(html);
}

function counterElement(editor) {
    return document.getElementById(counterId(editor));
}

function counterId(editor) {
    return 'cke_' + editor.name;
}

function displayCharCountForLongText(objTextbox) {
    if ($($(objTextbox)[0]).attr('maxlength') >= 0) {
        var numberOfEnters = 0;
        maxLength = $($(objTextbox)[0]).attr('maxlength');
        if ($(objTextbox).val().match(new RegExp('\n', 'g')) != null) {
            numberOfEnters = $(objTextbox).val().match(new RegExp('\n', 'g')).length;
        }
        length = $(objTextbox).val().length;
        count = $(objTextbox).val().length + numberOfEnters;
        if (count > maxLength) {
            strTrim(objTextbox);
        }
        if ($($(objTextbox)[0]).attr('id')) {
            $(document.getElementById('dv_' + $($(objTextbox)[0]).attr('id'))).remove()
            $(objTextbox).after('<div class="characterCounterLabel" style="text-align:right;margin-top: 2px;margin-bottom: 2px;font-style: italic;" id="' + 'dv_' + $($(objTextbox)[0]).attr('id') + '"> ' + count +' ' + window.counterOf +' ' + $($(objTextbox)[0]).attr('maxlength')+' ' + window.counterCharacters + '</div>');
        }
        if ($($(objTextbox)[0]).attr('data-id')) {
            $(document.getElementById('dv_' + $($(objTextbox)[0]).attr('data-id'))).remove()
            $(objTextbox).after('<div class="characterCounterLabel" style="text-align:right;margin-top: 2px;margin-bottom: 2px;font-style: italic;" id="' + 'dv_' + $($(objTextbox)[0]).attr('data-id') + '"> ' + count +' '+ window.counterOf +' ' + $($(objTextbox)[0]).attr('maxlength')+' ' + window.counterCharacters + ' </div>');
        }
    }
}

function getTextFromHTML(obj, editor, limit) {
    var arrNodeText = [];
    var mapNodeText = [];
    var extracharacters = count - limit;
    if (extracharacters > 0) {
        var ni = document.createNodeIterator(obj.body, NodeFilter.SHOW_TEXT, null, false);
        var nodeLine = ni.nextNode(); // go to first node of our NodeIterator    

        while (nodeLine) {
            if (nodeLine.nodeValue.trim().length > 0)
                arrNodeText.push(nodeLine.nodeValue);
            nodeLine = ni.nextNode();
        }

        arrNodeText = arrNodeText.reverse();

        for (var i = 0; i < arrNodeText.length; i++) {
            if (extracharacters > 0) {
                var objectNode = new Object();
                objectNode.nodevalold = arrNodeText[i];
                if (extracharacters < arrNodeText[i].length) {
                    var strold = arrNodeText[i].substring(0, arrNodeText[i].length - extracharacters);
                    objectNode.nodevalnew = strold.trim();
                    extracharacters -= extracharacters;
                } else {
                    objectNode.nodevalnew = "";
                    extracharacters -= arrNodeText[i].length;
                }
                mapNodeText.push(objectNode);
            }
        }
        var htmltext = editor.getData().replace("&nbsp;", " ");
        for (var i = 0; i < mapNodeText.length; i++) {
            htmltext = udfreplace(htmltext, mapNodeText[i].nodevalold.trim(), mapNodeText[i].nodevalnew);
        }

        if (extracharacters > 0) {
            alert("Data contains more characters than the character limit");
            editor.setData('');
        } else
            editor.setData(htmltext);
    }
}


function loadXMLString(txt) {
    if (window.DOMParser) {
        parser = new DOMParser();
        xmlDoc = parser.parseFromString(txt, "text/html");
    } else // Internet Explorer
    {
        xmlDoc = new ActiveXObject("Microsoft.XMLDOM");
        xmlDoc.async = false;
        xmlDoc.loadXML(txt);
    }
    return xmlDoc;
}

function udfreplace(str, streplacefrom, streplaceto) {
    var index = str.lastIndexOf(streplacefrom);
    if (index >= 0) {
        return str.substring(0, index) + streplaceto + str.substring(index + streplacefrom.length);
    }
}