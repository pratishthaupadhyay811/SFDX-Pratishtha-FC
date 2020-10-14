function initialize(){
    $("[id$=pnlSubject]").focus(function(){                
        focusErrorControl(); 
        return false;
    });
    $('.pbHeader table').addClass('pbHeader_border');
    $('.bPageBlock .detailList tr th').addClass('pb_table_border');
    $('.bPageBlock .detailList tr td').addClass('pb_table_border');
}

function clearList() {
    getOppTeamMember();
}; 

function setcharcount()
        {
           
            setCharCountForTextArea();
        }
        function focusErrorControl() {
            if($("[id$=pnlCamp]").val()=="0"){                  
                $("[id$=pnlCamp]").focus();}
            else if($("[id$=pnlOpp]").val()=="0"){                  
                $("[id$=pnlOpp]").focus();}
            else if($("[id$=pnlSubject]").val()==""){                   
                $("[id$=pnlSubject]").focus();}
            else if($("[id$=pnlBody]").val()==""){                  
                $("[id$=pnlBody]").focus();}
        }