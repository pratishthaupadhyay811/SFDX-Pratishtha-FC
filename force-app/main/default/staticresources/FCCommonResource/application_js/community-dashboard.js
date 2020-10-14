function navigateToCommunity(element)
    {
        top.location.href = element.value;
    }
    $(document).ready(function(){        
        $("[id$='switchcommunity'] option").each(function(){ 
            if(this.index == 0)
                $(this).prop('selected','true');
           
        });
    });