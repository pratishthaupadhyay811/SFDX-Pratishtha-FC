$(document).ready(function() {
    try {
		var isApplicationDetailsTab;
        var links = document.getElementById('tabBar');
        var iCount = 0;
		var jsTabMode;
		
		removeMenuLink();
		
        for (iCount = 0; iCount < links.childNodes.length; iCount++) {
            if (links.childNodes[iCount].getAttribute('id').includes('_Tab')) {
                links.childNodes[iCount].addEventListener('click',
                    function(event) {
							targetLink = event.target;
							attachmentDesc = null;
							attachmentLabel = null;	
							attachmentChanged = false;
							if(AttachQuestionCount>0 && AttachQuestionCount!=null)
								for(i=1;i<=AttachQuestionCount; i++)
								{
									attachmentDesc = $("[data-id$=textAreaDescription" + i + "]").val();
									if($(".lblFileInput")[i - 1] != undefined)
									  attachmentLabel = $(".lblFileInput")[i - 1].innerText;
									if((attachmentDesc != null && attachmentDesc != '') || (attachmentLabel != 	'No file chosen' && attachmentLabel != null && attachmentLabel != undefined))  
									{
										attachmentChanged = true;
										isAttachmentRecordChanged=true;
										break;
									}
								}
							if (jsMode == 'edit' && !isJSViewRecordLink) {
                            if (isRecordChanged || !isUploadProcessQueueEmpty()) {

                                event.preventDefault();
                                $(jQuery('[id$=ModalOutPanel]')[0]).show();
                            }
							}
							else if(!enforceNavigate && (!isUploadProcessQueueEmpty() && bIsApplicationSubmitted) || (bIsApplicationSubmitted && isRecordChanged && isDescChange()))
					        {
					        	 event.preventDefault();
					            $(jQuery('[id$=ModalOutPanelForSubmittedApplication]')[0]).show(); 
					            return false; 
					        }
							           
                    }
                );
            }
        }
        var noFileChosenLabel = ($('.lblFileInput')[0] == undefined || $('.lblFileInput')[0].innerText == undefined) ? null : $('.lblFileInput')[0].innerText;
    } catch (ex) {
        console.log(ex);
    }
});



function removeMenuLink()
{
   arrMenuLink = $('a.menuButtonMenuLink');
   if(arrMenuLink==undefined)
      return;
   for(index=0;index<arrMenuLink.length;index++){
      if(arrMenuLink[index].href.search('logout')<0)
         jQuery(arrMenuLink[index]).remove();
  }
};