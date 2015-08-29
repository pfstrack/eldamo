package xdb.dom;

import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.Writer;
import java.util.Collections;
import java.util.Iterator;
import java.util.Map;
import java.util.Properties;

import javax.xml.transform.OutputKeys;
import javax.xml.transform.stream.StreamResult;
import javax.xml.transform.stream.StreamSource;

import net.sf.saxon.Configuration;
import net.sf.saxon.Controller;
import net.sf.saxon.om.NamespaceResolver;
import net.sf.saxon.query.DynamicQueryContext;
import net.sf.saxon.query.ModuleURIResolver;
import net.sf.saxon.query.StaticQueryContext;
import net.sf.saxon.query.XQueryExpression;
import net.sf.saxon.trans.XPathException;

import org.w3c.dom.Node;

import xdb.config.QueryConfigManager;
import xdb.dom.impl.NodeImpl;
import xdb.util.XmlUtil;

/**
 * Engine for executing XQqueries. Take care with XQuery because it may not scale well for all types of queries.
 * 
 * @author Paul Strack
 */
public final class XQueryEngine {

    private XQueryEngine() {
    }

    @SuppressWarnings("serial")
    private static final ModuleURIResolver MR = new ModuleURIResolver() {
        public StreamSource[] resolve(String moduleURI, String baseURI, String[] locations)
            throws XPathException {
            try {
                int lastSlash = moduleURI.lastIndexOf('/');
                if (lastSlash >= 0) {
                    moduleURI = moduleURI.substring(lastSlash + 1);
                }
                String path = QueryConfigManager.getConfigRoot() + "/" + moduleURI;
                StreamSource src;
                src = new StreamSource(new FileInputStream(path), path);
                StreamSource[] srcs = { src };
                return srcs;
            } catch (FileNotFoundException e) {
                return null;
            }
        }
    };

    private static final NamespaceResolver NR = new NamespaceResolver() {

        public String getURIForPrefix(String arg0, boolean arg1) {
            if ("xdb".equals(arg0)) {
                return "java:xdb.dom.CustomFunctions";
            }
            return null;
        }

        public Iterator<String> iteratePrefixes() {
            return Collections.singletonList("xdb").iterator();
        }
    };

    /**
     * Perform an xquery.
     * 
     * @param context
     *            The context.
     * @param xquery
     *            The xquery.
     * @param params
     *            Query parameters.
     * @param out
     *            The output stream.
     * @param outputType
     *            The output type.
     * @throws XPathException
     *             For errors.
     */
    public static void query(Node context, String xquery, Map<String, String> params, Writer out,
        String outputType) throws XPathException {
        final Configuration config = XmlUtil.SAXON_CONFIG;
        final StaticQueryContext sqc = new StaticQueryContext(config);
        sqc.setModuleURIResolver(MR);
        sqc.setExternalNamespaceResolver(NR);
        final XQueryExpression expression = sqc.compileQuery(xquery); // TODO : cache
        Controller controller = expression.newController();
        controller.checkImplicitResultTree();

        final DynamicQueryContext queryContext = new DynamicQueryContext(config);
        for (String key : params.keySet()) {
            queryContext.setParameter(key, params.get(key));
        }
        queryContext.setContextItem((NodeImpl) context);
        final Properties props = new Properties();
        props.setProperty(OutputKeys.METHOD, outputType);
        props.setProperty(OutputKeys.INDENT, "yes");
        expression.run(queryContext, new StreamResult(out), props);
    }
}
