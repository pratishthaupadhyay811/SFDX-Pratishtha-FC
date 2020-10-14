@isTest
public class XMLDomTest
{
        public static testMethod void getElement(){
        String returnValue = null;
        XMLDom xmlDomcontroller = new XMLDom();
        XMLDom.Element elements = new  XMLDom.Element('');
        returnValue = elements.getAttribute('Test');
        System.assertEquals(null, returnValue);
        returnValue = elements.path();
        System.assertEquals('/', returnValue);
        returnValue = elements.getValue('Test');
        elements.firstChild();
        elements.getElementsByPath('/test/01');
        elements = elements.ownerDocument();
        System.assert(elements != null);
        elements = elements.cloneNode();
        System.assert(elements != null);
        returnValue = elements.textContent();
        Boolean bvalue = elements.hasChildNodes();
        System.assertEquals(false, bvalue);
        bvalue = elements.isEqualNode(elements);
        System.assertEquals(true, bvalue);
        bvalue = elements.hasAttributes();
        System.assertEquals(false, bvalue);
        bvalue = elements.isSameNode(elements);
        System.assertEquals(true, bvalue);
    }
    public static testMethod void doTestXmlParsing()
    {
        XMLDom xmlDomcontroller = new XMLDom('<book>non-xml=text</book>');
        xmlDomcontroller.parseFromString('non-xml-text');
        string xmlText = '<bookstore><book>' + '<title>Everyday Italian</title>' + '<author>Giada De Laurentiis</author>' + '<year>2005</year>' + '</book></bookstore>';
        xmlDomcontroller.parseFromString(xmlText);
        xmlDomcontroller.getElementsByTagName('bookstore');
        xmlDomcontroller.getElementByTagName('bookstore');
        XMLDom.Element element = xmlDomcontroller.ownerDocument();
        xmlDomcontroller.dumpAll();
        XMLDom.Element[] lstElements = new XMLDom.Element[]{ element };
        xmlDomcontroller.dumpList(lstElements);
        String xmlToString = xmlDomcontroller.toXmlString();
        System.assert(xmlToString.length() > 0);
    }
}