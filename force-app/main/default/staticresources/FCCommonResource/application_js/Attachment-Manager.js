$(document).ready(function() {
    try {
        sforce.connection.sessionId = __sfdcSessionId;
        if (UserContext.siteUrlPrefix != "undefined")
            sforce.connection.serverUrl = UserContext.siteUrlPrefix + "/services/Soap/u/34.0";

        //var noFileChosenLabel = $('.lblFileInput')[0].innerText;
    } catch (ex) {
        console.log(ex);
    }
});
function newGUID() {
    function s4() {
        return Math.floor((1 + Math.random()) * 0x10000).toString(16).substring(1);
    }
    return s4() + s4() + '-' + s4() + '-' + s4() + '-' + s4() + '-' + s4() + s4() + s4() + '-' + Date.now();
}


function asyncScanFile(strGUID, newAttachmentFile, strOrgID, isFeedAttachmentEnabled, questionAttachmentID) {
    $.ajax({
        url: virusScanURL,
        type: "POST",
        dataType: "xml",
        data: '<?xml version="1.0" encoding="utf-8"?>\
                                <soap12:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soap12="http://www.w3.org/2003/05/soap-envelope">\
                                    <soap12:Body>\
                                        <ScanFile xmlns="http://tempuri.org/">\
                                            <fileDetailInfo>\
                                                <GUID>' + strGUID + '</GUID>\
                                                <FileName>' + newAttachmentFile.ame + '</FileName>\
                                                <DataInBase64>' + newAttachmentFile.Body + '</DataInBase64>\
                                                <OrgID>' + strOrgID + '</OrgID>\
                                            </fileDetailInfo>\
                                        </ScanFile>\
                                    </soap12:Body>\
                                </soap12:Envelope>',
        processData: false,
        contentType: "text/xml; charset=\"utf-8\"",
        success: function(scanFileData, textStatus, jqXHR) {
            IsInfected = $.parseJSON(scanFileData.getElementsByTagName('IsInfected')[0].innerHTML);
            var uploadSuccess = false;

            if (IsInfected != undefined)
                if (!IsInfected) {
                    if (isFeedAttachmentEnabled) {
                        createFeedAttachment(newAttachmentFile, questionAttachmentID);
                    } else {
                        createAttachment(newAttachmentFile, questionAttachmentID);
                    }
                } else {
                    getScanMessage(IsInfected, null);
                    $(".spinnerContainer").hide();
                }
            asyncDeleteFile(strGUID, newAttachmentFile.name, newAttachmentFile.Body, strOrgID);
        },
        error: function(xhr, textStatus, error) {
            errorXHR = xhr;
            console.log("Exception : ScanFile :" + xhr + '-' + textStatus + '-' + error +'- IsInfected -'+IsInfected );
            asyncDeleteFile(strGUID, newAttachmentFile.name, newAttachmentFile.Body, strOrgID);
            getScanMessage(null, "Error while Scan File");
        }
    });
}


function asyncDeleteFile(strGUID, fileName, fileBody, strOrgID) {
    $.ajax({
        url: virusScanURL,
        type: "POST",
        dataType: "xml",
        data: '<?xml version="1.0" encoding="utf-8"?>\
        <soap12:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soap12="http://www.w3.org/2003/05/soap-envelope">\
            <soap12:Body>\
                <DeleteFile xmlns="http://tempuri.org/">\
                    <fileDetailInfo>\
                        <GUID>' + strGUID + '</GUID>\
                        <FileName>' + fileName + '</FileName>\
                        <DataInBase64>' + fileBody + '</DataInBase64>\
                        <OrgID>' + strOrgID + '</OrgID>\
                    </fileDetailInfo>\
                </DeleteFile>\
            </soap12:Body>\
        </soap12:Envelope>',
        processData: false,
        contentType: "text/xml; charset=\"utf-8\"",
        success: function(scanFileData, textStatus, jqXHR) {
            console.log(" scanFileData " + scanFileData);
        },
        error: function(xhr, textStatus, error) {
            console.log(" xhr " + xhr);
        }
    });
}

function createAttachment(newAttachmentFile, questionAttachmentID) {
    newAttachmentFile.ParentID = questionAttachmentID;
    uploadResult = sforce.connection.create([newAttachmentFile], {
        onSuccess: function(result) {
            if (!$.parseJSON(result[0].success)) {
                console.log("Exception : " + result[0].errors.message);
                getScanMessage(false, result[0].errors.message);
            } else {
                console.log("Upload Successful");
                getScanMessage(false, null);
            }
            setTimeout(function() {
                reloadAttachmentTable();
            }, 2000);
        },
        onFailure: function(message) {
            console.log("Exception : Upload Failed " + message);
	    if(message.detail!= undefined)
            	getScanMessage(false, message.detail.UnexpectedErrorFault.exceptionMessage);
            else
            	getScanMessage(false, message.faultstring);
        }
    });
}

function createFeedAttachment(newAttachmentFile, questionAttachmentID) {
    var feedItem = new sforce.SObject('FeedItem');
    feedItem.ContentFileName = newAttachmentFile.name;
    feedItem.ContentData = newAttachmentFile.Body;
    feedItem.Type = 'ContentPost';
    feedItem.ContentDescription = newAttachmentFile.Description;
    feedItem.Visibility = 'AllUsers';
    feedItem.ParentID = questionAttachmentID;
    uploadResult = sforce.connection.create([feedItem], {
        onSuccess: function(result) {
            if (result.length > 0) {
                if (!$.parseJSON(result[0].success)) {
                    console.log("Exception : " + result[0].errors.message);
                    getScanMessage(false, result[0].errors.message);
                } else {
                    console.log("Upload Successful");
                    getScanMessage(false, null);
                }
                setTimeout(function() {
                    reloadAttachmentTable();
                }, 2000);
            }
        },
        onFailure: function(message) {
            console.log("Exception : Upload Failed " + message);
	    if(message.detail!= undefined)
            	getScanMessage(false, message.detail.UnexpectedErrorFault.exceptionMessage);
            else
            	getScanMessage(false, message.faultstring);
        }
    });
}


function uploadAttachment(controlId, questionAttachmentID, attachedQuestionId, namingFormula, isFeedAttachmentEnabled, JSONApplication, strSelectedappId) {
    $(".spinnerContainer").show();
    $(".message").hide();
    window.scrollTo(0, 0);
    var uploadResult;
    var strObj = new String(attachedQuestionId);
    var reader = new FileReader();
    var attachFile = $("[id$=file" + controlId + "]")[0].files[0];
    var message = '';
    var strGUID = newGUID();
    var strOrgID = sforce.connection.getUserInfo().organizationId;

    try {
        if (attachFile == undefined) {
            alert('Attachment required to proceed');
            $(".spinnerContainer").hide();
            $("[id$=file" + controlId + "]").val("");
            $(".lblFileInput")[controlId - 1].innerText = noFileChosenLabel;
            //$("[data-id$=textAreaDescription" + controlId + "]").val("");
            isAttachmentRecordChanged = false;
            return false;
        }

        if ((isFeedAttachmentEnabled && attachFile.size > 2147483648) || (!isFeedAttachmentEnabled && attachFile.size > 26214400)) //Where 26214400 is byte equivalent of 25MB
        {
            alert('Attachment size not supported');
            $(".spinnerContainer").hide();
            $("[id$=file" + controlId + "]").val("");
            $(".lblFileInput")[controlId - 1].innerText = noFileChosenLabel;
            //$("[data-id$=textAreaDescription" + controlId + "]").val("");
            isAttachmentRecordChanged = false;
            return false;
        }

        var attachmentName = '';
        var AttachmentFileName = $("[id$=file" + controlId + "]").val().split("\\").pop(-1);
        var AttachmentFileDescription = $("[data-id$=textAreaDescription" + controlId + "]").val();
        var parts;
        if (namingFormula != "") {
            namingFormula = namingFormula.replace(/&#39;/ig, "'");
            parts = namingFormula.split('+');
        }

        if (namingFormula != "") {
            var extension = '';
            var filename;
            var isFileName = false;
            var isText = false;
            JSONApplication = JSON.parse(JSONApplication);

            for (i = 0; i < parts.length; i++) {
                isFileName = parts[i].includes('FileName');
                isText = parts[i].includes('\'');
                var strfieldName = parts[i].trim();

                if (isFileName == true) {
                    var filenameparts;
                    filename = AttachmentFileName;
                    if (filename != null && filename.length != 0)
                        filenameparts = filename.split('.');
                    if (filenameparts != null && filenameparts.length > 0)
                        extension = filenameparts[filenameparts.length - 1];
                    if (extension != null && extension.length != 0)
                        filename = filename.replace(new RegExp('.' + extension + '$'), '');
                    attachmentName = attachmentName + filename + '-';
                } else if (isText == true) {
                    var strStaticText;
                    if (parts[i].substring(1) != null && (parts[i].substring(1)).length != 0)
                        strStaticText = parts[i].substring(1).replace(/\'/ig, '');
                    attachmentName = attachmentName + strStaticText + '-';
                } else if (JSONApplication[strfieldName] != undefined) {
                    attachmentName = attachmentName + JSONApplication[strfieldName] + '-';
                }
            }
            attachmentName = attachmentName.replace(new RegExp('-' + '$'), '') + '.' + extension;
        } else
            attachmentName = AttachmentFileName;

        reader.onload = function(e) {
            var newAttachmentFile = new sforce.SObject('Attachment');
            newAttachmentFile = new sforce.SObject('Attachment');
            newAttachmentFile.IsPrivate = false;
            newAttachmentFile.ContentType = attachFile.type;
            newAttachmentFile.Body = (new sforce.Base64Binary(e.target.result)).toString();
            newAttachmentFile.Description = $("[data-id$=textAreaDescription" + controlId + "]").val();
            newAttachmentFile.name = attachmentName;


            if ($.parseJSON(virusEnabled)) {
                var protocol = null;
                var virusScanDomainURL = null;
                var domain = null;
                if (virusScanURL.includes("ScanManager/ScanFileManager.asmx")) {
                    if (virusScanURL.includes("://")) {
                        protocol = virusScanURL.split("://")[0];
                        virusScanDomainURL = virusScanURL.split("://")[1];
                        domain = virusScanDomainURL.split("/")[0];
                    }
                }
                if (domain == "54.175.87.42" || domain == "virusscan1.foundationconnect.org")
                    virusScanURL = "https://virusscan1.foundationconnect.org/ScanManager/ScanFileManager.asmx?wsdl";
                else if (domain == "54.175.69.46" || domain == "virusscan2.foundationconnect.org")
                    virusScanURL = "https://virusscan2.foundationconnect.org/ScanManager/ScanFileManager.asmx?wsdl";
                else
                    virusScanURL = "https://virusscan2.foundationconnect.org/ScanManager/ScanFileManager.asmx?wsdl";

                /*if (domain == "54.175.87.42" || domain == "virusscan1.foundationconnect.org" || domain == "54.175.69.46" || domain == "virusscan2.foundationconnect.org")
                    virusScanURL = "https://virusscanbal-1709244186.us-east-1.elb.amazonaws.com/ScanManager/ScanFileManager.asmx?wsdl";*/
                var IsInfected = undefined;

                $.ajax({
                    url: virusScanURL,
                    type: "POST",
                    dataType: "xml",
                    data: '<?xml version="1.0" encoding="utf-8"?>\
                    <soap12:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soap12="http://www.w3.org/2003/05/soap-envelope">\
                        <soap12:Body>\
                            <UploadFileToScan xmlns="http://tempuri.org/">\
                                <fileDetailInfo>\
                                    <GUID>' + strGUID + '</GUID>\
                                    <FileName>' + newAttachmentFile.name + '</FileName>\
                                    <DataInBase64>' + newAttachmentFile.Body + '</DataInBase64>\
                                    <OrgID>' + strOrgID + '</OrgID>\
                                </fileDetailInfo>\
                            </UploadFileToScan>\
                        </soap12:Body>\
                    </soap12:Envelope>',
                    processData: false,
                    contentType: "text/xml; charset=\"utf-8\"",
                    success: function(data, textStatus, jqXHR) {
                        if (data.getElementsByTagName('Success')[0].innerHTML) {
                            asyncScanFile(strGUID, newAttachmentFile, strOrgID, isFeedAttachmentEnabled, questionAttachmentID);
                        }
                    },
                    error: function(xhr, textStatus, error) {
                        xXHR = xhr;
                        xErr = error;
                        console.log("Exception : Upload to Scan :" + xhr + '-' + textStatus + '-' + error);
                        getScanMessage(null, "Error while Upload to Scan");
                    }
                });
            } else {
                if (isFeedAttachmentEnabled) {
                    createFeedAttachment(newAttachmentFile, questionAttachmentID);
                } else {
                    createAttachment(newAttachmentFile, questionAttachmentID);
                }
            }

            $("[id$=file" + controlId + "]").val("");
            $(".lblFileInput")[controlId - 1].innerText = noFileChosenLabel;
            //$("[data-id$=textAreaDescription" + controlId + "]").val("");
            isAttachmentRecordChanged = false;
        }
        reader.readAsBinaryString(attachFile);
    } catch (ex) {
        console.log('   Exception :  ' + ex);
    }
}
