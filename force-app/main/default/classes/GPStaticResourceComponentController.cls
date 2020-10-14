public class GPStaticResourceComponentController
{
    public String pageUrl { get; set; }
    public String staticResourceUrl { get; set; }

    public String applicationJSResources { get; set; }
    public String applicationCSSResources { get; set; }

    public List<String> applicationJSResourcesList {  get { return getResourcesList(applicationJSResources); } }
    public List<String> applicationCSSResourcesList {  get { return getResourcesList(applicationCSSResources); } }
    public List<String> getResourcesList( string resources )
    {
        if( resources != null )
        {
            Set<String> setNames = new Set<String>();
            List<String> lstNames = new List<String>();
            for( String name : resources.split(',',0) )
            {
                setNames.add( name.trim().toLowerCase() );
            }
            if( setNames != null && !setNames.isEmpty() )
            {
                lstNames.addAll(setNames);
            }
            return lstNames;
        }
        return null;
    }
}