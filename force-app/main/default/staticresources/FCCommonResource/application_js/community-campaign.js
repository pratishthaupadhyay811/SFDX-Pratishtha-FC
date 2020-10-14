$(document).ready(function () {
    //for encoding
    unescape();
    $('.mruList .campaignBlock').each(function () {
        $(this).find('a.campaignMru').attr('href', '{!JSENCODE(URLFOR($Page.CommunityCampaign))}?id=' + $(this).attr('data-hovid'));
        $(this).removeAttr('data-hovid');
    });
    $('.detail-view .col-1').addClass('detail-view_align');
    var attachments = $('.attachment-item')
    if (attachments.length <= 0)
        $('.sidebar-downloads').hide();
});
function checkFieldInSet(setOfFields,field)
{
    alert(setOfFields);
    alert(field);
    console.log(setOfFields);
    console.log(field);
}