package xdb.dom;

import java.io.InputStream;
import java.io.StringReader;
import junit.framework.TestCase;
import org.w3c.dom.Document;
import org.xml.sax.InputSource;

import xdb.config.ModelConfigManagerTest;
import xdb.dom.DomManager;
import xdb.dom.XmlParser;
import xdb.dom.impl.DocumentImpl;

public class DomManagerTest extends TestCase {

    public DomManagerTest(String testName) {
        super(testName);
    }

    public void testUpdate() throws Exception {
        DocumentImpl data = (DocumentImpl) parseFromFile("sample-data.xml");
        ModelConfigManagerTest.init();
        data.buildIndex();

        String xml = "<items>";
        xml += "<category id='Blade_Servers_1' name='New Name' publish-date='2006-11-17'>";
        xml += "<translation locale='en' name='Blade Servers' />";
        xml += "<children>";
        xml += "<product-ref idref='SB_6000_VMF_10GBE' />";
        xml += "<product-ref idref='Sun_Blade_6000_Modu' />";
        xml += "</children>";
        xml += "</category>";
        xml += "</items>";
        Document updates = parse(xml);

        DomManager.update(updates, data);
    }

    private Document parse(String xml) throws Exception {
        StringReader reader = new StringReader(xml);
        InputSource is = new InputSource(reader);
        return new XmlParser().parse(is);
    }

    private Document parseFromFile(String file) throws Exception {
        InputStream in = getClass().getResourceAsStream(file);
        InputSource is = new InputSource(in);
        return new XmlParser().parse(is);
    }
}
