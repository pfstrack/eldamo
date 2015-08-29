package xdb.dom;

import java.io.StringReader;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashSet;
import java.util.LinkedList;
import java.util.List;
import java.util.Set;

import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.parsers.ParserConfigurationException;

import net.sf.saxon.dom.NodeOverNodeInfo;
import net.sf.saxon.om.NodeInfo;

import org.w3c.dom.Document;
import org.w3c.dom.Element;
import org.w3c.dom.Node;
import org.w3c.dom.NodeList;
import org.xml.sax.InputSource;

import xdb.dom.impl.DocumentImpl;
import xdb.dom.impl.NodeImpl;

/**
 * Custom functions for XQuery/XPath/XSLT integration.
 * 
 * @author Paul Strack
 */
public final class CustomFunctions {

    private CustomFunctions() {
    }
    
    public static String currentYear() {
        return new java.text.SimpleDateFormat("yyyy").format(new java.util.Date());
    }

    /**
     * Get the delta between two strings.
     * 
     * @param compare
     *            The string to compare
     * @param item
     *            The string being compared with.
     * @return The delta (empty string if the same).
     */
    public static String delta(String compare, String with) {
        try {
            int first = 0;
            char[] c1 = compare.toCharArray();
            char[] c2 = with.toCharArray();
            while (first < c1.length && first < c2.length && c1[first] == c2[first]) {
                first++;
            }
            if ((first < c1.length && c1[first] == 'ʰ') || (first < c1.length && c1[first] == 'ʰ') && (first > 0)) {
                first--;
            }
            int last = 0;
            while (last < c1.length && last < c2.length && c1[c1.length - last - 1] == c2[c2.length - last - 1]) {
                last++;
            }
            last = c1.length - last;
            if (last == first && c1.length > c2.length) {
                last += (c1.length - c2.length);
            }
            return last <= first ? "ø" : compare.substring(first, last);
        } catch (Exception ex) {
            return "!!!";
        }
    }

    /**
     * Whether a list of nodes contains a given node.
     * 
     * @param nodes
     *            The list of nodes.
     * @param item
     *            The item that is contained.
     * @return True if the true is in the list.
     */
    public static boolean contains(List<Node> nodes, Node item) {
        for (Node node : nodes) {
            if (isSame(node, item)) {
                return true;
            }
        }
        return false;
    }

    /**
     * Whether two nodes are the same. Returns false if either node is null.
     * 
     * @param node1
     *            The first node.
     * @param node2
     *            The second node.
     * @return Whether two nodes are the same.
     */
    public static boolean isSame(Node node1, Node node2) {
        if (node1 == null) {
            return false;
        } else if (node2 == null) {
            return false;
        } else {
            return getUnderlyingNode(node1) == getUnderlyingNode(node2);
        }
    }

    /**
     * Whether two nodes are not the same. Returns false if either node is null.
     * 
     * @param node1
     *            The first node.
     * @param node2
     *            The second node.
     * @return Whether two nodes are not the same.
     */
    public static boolean isNotSame(Node node1, Node node2) {
        if (node1 == null) {
            return false;
        } else if (node2 == null) {
            return false;
        } else {
            return getUnderlyingNode(node1) != getUnderlyingNode(node2);
        }
    }

    /**
     * Get nodes for the given key.
     * 
     * @param context
     *            The context.
     * @param keyName
     *            The key name.
     * @param keyValue
     *            The key value.
     * @return The list of nodes matching the key value.
     */
    public static List<NodeInfo> key(Node context, String keyName, String keyValue) {
        context = getUnderlyingNode(context);
        List<Node> elements = keyNodes(context, keyName, keyValue);
        List<NodeInfo> result = new ArrayList<NodeInfo>(elements.size());
        for (Node node : elements) {
            result.add((NodeInfo) node);
        }
        return result;
    }

    /**
     * Get nodes that match all of a list of keys.
     * 
     * @param context
     *            The context.
     * @param keyName
     *            The key name.
     * @param keyValue
     *            The key values as a space-delimited list.
     * @return The list of nodes matching all key values.
     */
    public static List<NodeInfo> matchAllKeys(Node context, String keyName, String keyValues) {
    	List<NodeInfo> result = new LinkedList<NodeInfo>();
    	if (keyValues == null || keyValues.trim().length() == 0) {
    		return result;
    	}
    	String[] values = keyValues.split(" ");
    	result.addAll(key(context, keyName, values[0]));
    	for (int i = 1; i < values.length; i++) {
    		result.retainAll(key(context, keyName, values[i]));
    	}
        return result;
    }

    /**
     * Get nodes that match any of a list of keys.
     * 
     * @param context
     *            The context.
     * @param keyName
     *            The key name.
     * @param keyValue
     *            The key values as a space-delimited list.
     * @return The list of nodes matching all key values.
     */
    public static List<NodeInfo> matchAnyKey(Node context, String keyName, String keyValues) {
    	List<NodeInfo> result = new LinkedList<NodeInfo>();
    	if (keyValues == null || keyValues.trim().length() == 0) {
    		return result;
    	}
    	String[] values = keyValues.split(" ");
    	result.addAll(key(context, keyName, values[0]));
    	for (int i = 1; i < values.length; i++) {
    		result.addAll(key(context, keyName, values[i]));
    	}
        return result;
    }

    private static Node getUnderlyingNode(Node context) {
        if (context instanceof NodeOverNodeInfo) {
            NodeOverNodeInfo wrapper = (NodeOverNodeInfo) context;
            context = (NodeImpl) wrapper.getUnderlyingNodeInfo();
        }
        return context;
    }

    private static List<Node> keyNodes(Node context, String keyName, String keyValue) {
        DocumentImpl doc = (DocumentImpl) (context instanceof Document ? context : context.getOwnerDocument());
        return doc.getElementsFromKey(keyName, keyValue);
    }

    /**
     * Get all cognates to a reference element.
     * 
     * @param context
     *            The context.
     * @return The list of cognates.
     */
    public static List<NodeInfo> allReferenceCognates(Node context) {
        context = getUnderlyingNode(context);
        Set<Node> set = new HashSet<Node>();
        set.add(context);
        set = allReferenceCognates(set);
        List<NodeInfo> result = new ArrayList<NodeInfo>(set.size());
        for (Node node : set) {
            if (!getLang(node).equals(getLang(context))) {
                result.add((NodeInfo) node);
            }
        }
        return result;
    }

    /**
     * Get all cognates to a reference set.
     * 
     * @param set
     *            The set.
     * @return The list of cognates.
     */
    private static Set<Node> allReferenceCognates(Set<Node> set) {
        Set<Node> newSet = new HashSet<Node>();
        for (Node node : set) {
            Element element = (Element) node;
            String source = element.getAttribute("source");
            List<Node> keyNodes = keyNodes(node, "cognate-of-ref", source);
            newSet.addAll(keyNodes);

            List<Element> cognates = getChildren(element, "cognate");
            for (Element cognate : cognates) {
                source = cognate.getAttribute("source");
                newSet.addAll(keyNodes(node, "ref", source));
            }
        }
        newSet.addAll(set);
        if (newSet.size() <= set.size()) {
            return newSet;
        } else {
            return allReferenceCognates(newSet);
        }
    }

    private static List<Element> getChildren(Element element, String childName) {
        List<Element> result = new LinkedList<Element>();
        NodeList children = element.getChildNodes();
        for (int i = 0; i < children.getLength(); i++) {
            Node item = children.item(i);
            if (item instanceof Element && item.getNodeName().equals(childName)) {
                result.add((Element) item);
            }
        }
        return result;
    }

    /**
     * Get all cognates to a word element.
     * 
     * @param context
     *            The context.
     * @return The list of cognates.
     */
    public static List<NodeInfo> allWordCognates(Node context) {
        context = getUnderlyingNode(context);
        Set<Node> set = new HashSet<Node>();
        set.add(context);
        set = allWordCognates(set);
        List<NodeInfo> result = new ArrayList<NodeInfo>(set.size());
        for (Node node : set) {
            if (node != context) {
                result.add((NodeInfo) node);
            }
        }
        return result;
    }

    /**
     * Get all cognates to a word set.
     * 
     * @param set
     *            The set.
     * @return The list of cognates.
     */
    private static Set<Node> allWordCognates(Set<Node> set) {
        Set<Node> newSet = new HashSet<Node>();
        for (Node node : set) {
            Element element = (Element) node;
            String lang = getLang(element);
            String v = element.getAttribute("v");
            String key = lang + ":" + v;
            List<Node> cogsOf = keyNodes(node, "cognate-of", key);
            newSet.addAll(cogsOf);

            List<Element> cognates = getChildren(element, "cognate");
            for (Element cognate : cognates) {
                lang = cognate.getAttribute("l");
                v = cognate.getAttribute("v");
                key = lang + ":" + v;
                List<Node> cogs = keyNodes(node, "lang-word", key);
                newSet.addAll(cogs);
            }
        }
        newSet.addAll(set);
        if (newSet.size() <= set.size()) {
            return newSet;
        } else {
            return allWordCognates(newSet);
        }
    }

    private static String getLang(Node node) {
        if (node instanceof Element) {
            return getLang((Element) node);
        } else {
            return null;
        }
    }

    private static String getLang(Element element) {
        String lang = element.getAttribute("l");
        if (lang.equals("") && element.getParentNode() instanceof Element) {
            return getLang((Element) element.getParentNode());
        } else {
            return lang;
        }
    }

    /**
     * Convert a string to HTML.
     * 
     * @param html
     *            The html.
     * @return The result wrapped in a root element
     */
    public static List<Node> html(String html) {
        DocumentBuilder db = null; // TODO: Cleanup, using Saxon parser.
        try {
            db = DocumentBuilderFactory.newInstance().newDocumentBuilder();
        } catch (ParserConfigurationException e2) {
        }
        Document doc;
        try {
            doc = db.parse(new InputSource(new StringReader("<root>" + html + "</root>")));
        } catch (Exception e) {
            try {
                doc = db.parse(new InputSource(new StringReader("<root>ERROR:BAD_HTML - " + e + "</root>")));
            } catch (Exception e1) {
                return new ArrayList<Node>();
            }
        }
        NodeList links = doc.getElementsByTagName("a");
        for (int i=0; i < links.getLength(); i++) {
            Element link = (Element) links.item(i);
            String lang = link.getAttribute("l");
            if (lang != null && lang.length() > 0) {
                String v = link.getAttribute("v");
                if (v != null && v.length() > 0 && link.getChildNodes().getLength() == 0) {
                    link.setTextContent(v);
                    link.removeAttribute("v");
                }
                String value = v == null ? link.getTextContent() : v;
                String hashcode = hashcode(lang, value);
                link.setAttribute("href", "../words/word-" + hashcode + ".html");
                link.removeAttribute("l");
            }
            String ref = link.getAttribute("ref");
            if (ref != null && ref.length() > 0) {
                if (link.getChildNodes().getLength() == 0) {
                    link.setTextContent(ref);
                }
                link.removeAttribute("ref");
                link.setAttribute("href", "../references/ref-" + ref + ".html");
            }
        }
        NodeList list = doc.getDocumentElement().getChildNodes();
        List<Node> result = new ArrayList<Node>(list.getLength());
        for (int i = 0; i < list.getLength(); i++) {
            result.add(list.item(i));
        }
        return result;
    }

    /**
     * Get the hashcode for a node.
     * 
     * @param node
     *            The node.
     * @return The hashcode.
     */
    public static String hashcode(Node node) {
        if (node.getNodeName().equals("ref")) {
            Element element = (Element) node;
            String src = element.getAttribute("source");
            return toHash(src);
        } else if (node.getNodeName().equals("word")) {
            Element element = (Element) node;
            String value = element.getAttribute("v");
            String lang = getLang(element);
            return hashcode(lang, value);
        }
        return "";
    }

    private static String hashcode(String lang, String value) {
        value = lang + "::" + value;
        char[] chars = value.toCharArray();
        Arrays.sort(chars);
        String sort = new String(chars);
        return toHash(value + sort);
    }

    /**
     * Only the distinct nodes in a list.
     * 
     * @param list
     *            of nodes. The node.
     * @return The distinct nodes.
     */
    public static List<Node> distinct(List<Node> nodes) {
        List<Node> result = new LinkedList<Node>();
        for (Node node : nodes) {
            if (!result.contains(node)) {
                result.add(node);
            }
        }
        return result;
    }

    /**
     * Whether the nodes are the same.
     * 
     * @param node1
     *            Node 1.
     * @param node2
     *            Node 2.
     * @return Whether the nodes are the same.
     */
    public static boolean same(Node node1, Node node2) {
        return node1 == node2;
    }

    private static String toHash(String v) {
        long hashCode = v.hashCode();
        hashCode += Integer.MAX_VALUE;
        return String.valueOf(hashCode);
    }
}
