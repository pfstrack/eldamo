package xdb.dom;

import java.util.Collections;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import javax.xml.namespace.NamespaceContext;
import javax.xml.namespace.QName;
import javax.xml.xpath.XPath;
import javax.xml.xpath.XPathConstants;
import javax.xml.xpath.XPathExpression;
import javax.xml.xpath.XPathExpressionException;
import javax.xml.xpath.XPathFactory;
import javax.xml.xpath.XPathVariableResolver;

import net.sf.saxon.xpath.XPathFactoryImpl;

import org.w3c.dom.Node;

import xdb.util.XmlUtil;

/**
 * Engine for executing parametrized XPath queries. Currently this engine uses the Saxon xpath
 * implementation, which supports XPath 2.0.
 * 
 * @author Paul Strack
 */
public final class XPathEngine {

    private XPathEngine() {
    }

    /**
     * Namespace URI for Xpaths. It prompts the XPath processor to use the functions in
     * {@link xdb.dom.CustomFunctions}.
     */
    public static final String XPATH_FUNCTION_URI = "java:xdb.dom.CustomFunctions";

    private static final NamespaceContext NAMESPACE_CONTEXT = new NamespaceContext() {

        public String getNamespaceURI(String prefix) {
            return XPATH_FUNCTION_URI;
        }

        public String getPrefix(String uri) {
            return "custom";
        }

        public Iterator<String> getPrefixes(String arg0) {
            return Collections.singletonList("custom").iterator();
        }
    };

    /**
     * Query the Document Object Model with a parametrized XPath. Parameters used in the path must
     * be specified using the ${variable-name} syntax. Parameter values must appear in the parameter
     * map. For example, the variable name $id is mapped to the parameter value with the key "id".
     * 
     * @param context
     *            The context for the XPath.
     * @param path
     *            The xpath.
     * @param params
     *            Parameters.
     * @return The result.
     * @throws XPathExpressionException
     *             For errors.
     */
    public static List<Node> query(Node context, String path, final Map<String, String> params)
        throws XPathExpressionException {
        XPathExpression expression = getParametrizedXPath(path, params);
        return query(context, expression);
    }

    /**
     * Query against a pre-compiled expression.
     * 
     * @param context
     *            The context node.
     * @param expression
     *            The expression.
     * @return The result.
     * @throws XPathExpressionException
     *             For errors.
     */
    @SuppressWarnings("unchecked")
    public static List<Node> query(Node context, XPathExpression expression)
        throws XPathExpressionException {
        Object result = expression.evaluate(context, XPathConstants.NODESET);
        if (result == null) {
            return Collections.emptyList();
        } else if (result instanceof List) {
            return (List<Node>) result;
        } else {
            throw new IllegalStateException("Unexpected return type " + result.getClass());
        }
    }

    /**
     * Query the Document Object Model with a parametrized XPath. Parameters used in the path must
     * be specified using the ${variable-name} syntax. Parameter values must appear in the parameter
     * map. For example, the variable name $id is mapped to the parameter value with the key "id".
     * 
     * @param context
     *            The context for the XPath.
     * @param path
     *            The xpath.
     * @param params
     *            Parameters.
     * @return The result as a string.
     * @throws XPathExpressionException
     *             For errors.
     */
    public static String stringQuery(Node context, String path, final Map<String, String> params)
        throws XPathExpressionException {
        XPathExpression expression = getParametrizedXPath(path, params);
        return stringQuery(context, expression);
    }

    /**
     * Query against a pre-compiled expression.
     * 
     * @param context
     *            The context node.
     * @param expression
     *            The expression.
     * @return The result.
     * @throws XPathExpressionException
     *             For errors.
     */
    public static String stringQuery(Node context, XPathExpression expression)
        throws XPathExpressionException {
        return (String) expression.evaluate(context, XPathConstants.STRING);
    }

    /**
     * Get a paramaterized XPathExpression ready for repeated execution. The parameter map is used
     * for all xpath executions. The parameter values can be changed between executions by changing
     * the values in the map.
     * 
     * @param path
     *            The xpath.
     * @param params
     *            The map containing parameters and their values.
     * @return The XPathExpression for execution.
     * @throws XPathExpressionException
     *             For errors.
     */
    public static XPathExpression getParametrizedXPath(String path, final Map<String, String> params)
        throws XPathExpressionException {
        XPath xpath = getBaseXPath();
        XPathVariableResolver resolver = new XPathVariableResolver() {

            public Object resolveVariable(QName variableName) {
                if (params == null) {
                    return null;
                }
                return params.get(variableName.getLocalPart());
            }
        };
        xpath.setXPathVariableResolver(resolver);
        return xpath.compile(path);
    }

    /**
     * Get an unparamaterized XPathExpression ready for repeated execution.
     * 
     * @param path
     *            The xpath.
     * @return The XPathExpression for execution.
     * @throws XPathExpressionException
     *             For errors.
     */
    public static XPathExpression getUnparametrizedXPath(String path)
        throws XPathExpressionException {
        XPath xpath = getBaseXPath();
        xpath.setXPathVariableResolver(null);
        return xpath.compile(path);
    }

    private static XPath getBaseXPath() {
        XPathFactory xpathFactory = getXPathFactory();
        XPath xpath = xpathFactory.newXPath();
        xpath.setNamespaceContext(NAMESPACE_CONTEXT);
        return xpath;
    }

    /** Hard-code Saxon xpath implementation, since Xalan is xpath 1.0 and flaky. */
    private static XPathFactory getXPathFactory() {
        return new XPathFactoryImpl(XmlUtil.SAXON_CONFIG);
    }
}
