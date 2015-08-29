package xdb.dom;

import java.io.StringReader;
import java.io.Writer;
import java.util.Map;

import javax.xml.transform.Result;
import javax.xml.transform.Source;
import javax.xml.transform.TransformerException;
import javax.xml.transform.stream.StreamResult;
import javax.xml.transform.stream.StreamSource;

import net.sf.saxon.Controller;
import net.sf.saxon.s9api.SaxonApiException;
import net.sf.saxon.s9api.XsltCompiler;
import net.sf.saxon.s9api.XsltExecutable;
import net.sf.saxon.s9api.XsltTransformer;

import org.w3c.dom.Node;

import xdb.dom.impl.NodeImpl;
import xdb.util.XmlUtil;

/**
 * Engine for executing XSL transformations. Take care with XSL because it may not scale well for all types of queries.
 * 
 * @author Paul Strack
 */
public final class XslEngine {

    private XslEngine() {
    }

    /**
     * Perform an xsl transform.
     * 
     * @param context
     *            The context.
     * @param xsl
     *            The xsl.
     * @param params
     *            Query parameters.
     * @param out
     *            The output stream.
     * @param outputType
     *            The output type.
     * @throws SaxonApiException
     * @throws TransformerException
     */
    public static void query(Node context, String xsl, Map<String, String> params, Writer out,
        String outputType) throws SaxonApiException, TransformerException {
        XsltCompiler compiler = XmlUtil.PROCESSOR.newXsltCompiler();
        StringReader reader = new StringReader(xsl);
        Source xslSrc = new StreamSource(reader);
        XsltExecutable executable = compiler.compile(xslSrc); // TODO : cache

        XsltTransformer transformer = executable.load();
        Controller controller = transformer.getUnderlyingController();
        for (String key : params.keySet()) {
            controller.setParameter(key, params.get(key));
        }
        Result result = new StreamResult(out);
        controller.transformDocument((NodeImpl) context, result);
    }
}
