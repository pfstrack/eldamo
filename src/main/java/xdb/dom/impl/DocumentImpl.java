package xdb.dom.impl;

import java.util.Collections;
import java.util.Comparator;
import java.util.HashMap;
import java.util.HashSet;
import java.util.Iterator;
import java.util.LinkedList;
import java.util.List;
import java.util.Map;
import java.util.Set;

import javax.xml.xpath.XPathExpressionException;

import net.sf.saxon.om.DocumentInfo;
import net.sf.saxon.om.NodeInfo;
import net.sf.saxon.type.Type;

import org.w3c.dom.Attr;
import org.w3c.dom.CDATASection;
import org.w3c.dom.Comment;
import org.w3c.dom.DOMConfiguration;
import org.w3c.dom.DOMException;
import org.w3c.dom.DOMImplementation;
import org.w3c.dom.Document;
import org.w3c.dom.DocumentFragment;
import org.w3c.dom.DocumentType;
import org.w3c.dom.Element;
import org.w3c.dom.EntityReference;
import org.w3c.dom.Node;
import org.w3c.dom.NodeList;
import org.w3c.dom.ProcessingInstruction;
import org.w3c.dom.Text;

import xdb.config.ModelConfigManager;
import xdb.config.ModelConfigManager.Key;
import xdb.dom.CustomFunctions;
import xdb.dom.XPathEngine;

/**
 * Implementation of Document class.
 * 
 * @author ps142237
 */
public class DocumentImpl extends NodeImpl implements Document, DocumentInfo {

    public static final DOMImplementationImpl IMPLEMENTATION = new DOMImplementationImpl();
    private NodeList childNodes = NodeListImpl.EMPTY_LIST;
    private Map<String, String> nodeNames;
    private Map<String, Element> elementById = new HashMap<String, Element>();
    private volatile Map<String, Map<String, List<Node>>> keyMap = Collections.emptyMap();
    private final int documentNumber;

    /**
     * Constructor.
     * 
     * @param position
     *            Node position within document.
     */
    public DocumentImpl(int position) {
        super(position);
        documentNumber = getConfiguration().getDocumentNumberAllocator().allocateDocumentNumber();
    }

    @Override
    public Node adoptNode(Node source) throws DOMException {
        throw DOMImplementationImpl.notSupportedErr();
    }

    @Override
    public Attr createAttribute(String name) throws DOMException {
        throw DOMImplementationImpl.notSupportedErr();
    }

    @Override
    public Attr createAttributeNS(String namespaceURI, String qualifiedName) throws DOMException {
        throw DOMImplementationImpl.notSupportedErr();
    }

    @Override
    public CDATASection createCDATASection(String data) throws DOMException {
        throw DOMImplementationImpl.notSupportedErr();
    }

    @Override
    public Comment createComment(String data) {
        throw DOMImplementationImpl.notSupportedErr();
    }

    @Override
    public DocumentFragment createDocumentFragment() {
        throw DOMImplementationImpl.notSupportedErr();
    }

    @Override
    public Element createElement(String tagName) throws DOMException {
        throw DOMImplementationImpl.notSupportedErr();
    }

    @Override
    public Element createElementNS(String namespaceURI, String qualifiedName) throws DOMException {
        throw DOMImplementationImpl.notSupportedErr();
    }

    @Override
    public EntityReference createEntityReference(String name) throws DOMException {
        throw DOMImplementationImpl.notSupportedErr();
    }

    @Override
    public ProcessingInstruction createProcessingInstruction(String target, String data) throws DOMException {
        throw DOMImplementationImpl.notSupportedErr();
    }

    @Override
    public Text createTextNode(String data) {
        throw DOMImplementationImpl.notSupportedErr();
    }

    @Override
    public DocumentType getDoctype() {
        return null;
    }

    @Override
    public Element getDocumentElement() {
        return (Element) this.getFirstChild();
    }

    @Override
    public String getDocumentURI() {
        return null;
    }

    @Override
    public DOMConfiguration getDomConfig() {
        throw DOMImplementationImpl.notSupportedErr();
    }

    @Override
    public Element getElementById(String id) {
        return elementById.get(id);
    }

    @Override
    public NodeList getElementsByTagName(String tagname) {
        String name = getCanonicalName(tagname);
        if (name == null) {
            return NodeListImpl.EMPTY_LIST;
        }
        List<Node> list = new LinkedList<Node>();
        ElementBase.addByTagName(getChildNodes(), name, list);
        return NodeListImpl.toNodeList(list);
    }

    @Override
    public NodeList getElementsByTagNameNS(String namespaceURI, String localName) {
        return getElementsByTagName(localName);
    }

    @Override
    public DOMImplementation getImplementation() {
        return IMPLEMENTATION;
    }

    @Override
    public String getInputEncoding() {
        return null;
    }

    @Override
    public boolean getStrictErrorChecking() {
        return false;
    }

    @Override
    public String getXmlEncoding() {
        return null;
    }

    @Override
    public boolean getXmlStandalone() {
        return false;
    }

    @Override
    public String getXmlVersion() {
        return "1.0";
    }

    @Override
    public Node importNode(Node importedNode, boolean deep) throws DOMException {
        if (!deep || !(importedNode instanceof ElementBase)) {
            throw DOMImplementationImpl.badImportErr();
        }
        return importNode((ElementBase) importedNode, this);
    }

    private ElementBase importNode(ElementBase element, Node parent) throws DOMException {
        String name = getOrSetCanonicalName(element.getNodeName());
        int position = element.getPosition();
        ElementBase result = null;
        if (element instanceof TextElementImpl) {
            String text = element.getTextContent();
            result = new TextElementImpl(position, name, parent, text);
        } else if (element instanceof ElementImpl) {
            result = new ElementImpl(position, name, parent);
        }

        NamedNodeMapImpl atts = (NamedNodeMapImpl) element.getAttributes();
        String[][] rawAtts = atts.getRawAttributes();
        String[][] newAtts = new String[rawAtts.length][2];
        for (int i = 0; i < rawAtts.length; i++) {
            String[] att = rawAtts[i];
            String attName = getOrSetCanonicalName(att[0]);
            String[] newAtt = { attName, att[1] };
            newAtts[i] = newAtt;
        }
        result.setAttributes(new NamedNodeMapImpl(result, newAtts));

        if (element instanceof ElementImpl) {
            ElementImpl resultImpl = (ElementImpl) result;
            NodeList children = element.getChildNodes();
            for (int i = 0; i < children.getLength(); i++) {
                ElementBase child = (ElementBase) children.item(i);
                child = importNode(child, result);
                resultImpl.addChild(child);
            }
            resultImpl.fixChildren();
        }

        return result;
    }

    @Override
    public void normalizeDocument() {
    }

    @Override
    public Node renameNode(Node n, String namespaceURI, String qualifiedName) throws DOMException {
        throw DOMImplementationImpl.notSupportedErr();
    }

    @Override
    public void setDocumentURI(String documentURI) {
    }

    @Override
    public void setStrictErrorChecking(boolean strictErrorChecking) {
    }

    @Override
    public void setXmlStandalone(boolean xmlStandalone) throws DOMException {
    }

    @Override
    public void setXmlVersion(String xmlVersion) throws DOMException {
    }

    @Override
    public short getNodeType() {
        return Node.DOCUMENT_NODE;
    }

    @Override
    public String getNodeValue() throws DOMException {
        return null;
    }

    @Override
    public String getNodeName() {
        return "#document";
    }

    @Override
    public NodeList getChildNodes() {
        return this.childNodes;
    }

    @Override
    public boolean hasChildNodes() {
        return true;
    }

    @Override
    public Node getParentNode() {
        return null;
    }

    @Override
    public String getTextContent() throws DOMException {
        return null;
    }

    @Override
    public Node getPreviousSibling() {
        return null;
    }

    @Override
    public Node getNextSibling() {
        return null;
    }

    /**
     * Get the canonical name string for elements and attributes. This string is the same object used for the node name
     * of strings and elements in the document, suitable for comparison using "==" instead of "String.equals()". Using
     * the canonical name string instead of an otherwise equal string can significantly improve performance.
     * 
     * TODO: Deprecate and replace with optimized logic based on Saxon name-pool.
     * 
     * @param name
     *            The name.
     * @return The canonical name string.
     */
    public String getCanonicalName(String name) {
        return this.nodeNames.get(name);
    }

    private String getOrSetCanonicalName(String name) {
        String canonical = this.nodeNames.get(name);
        if (canonical == null) {
            this.nodeNames.put(name, name);
            canonical = name;
        }
        return canonical;
    }

    /**
     * Get elements by a key from the indexes.
     * 
     * @param key
     *            The key/index name.
     * @param value
     *            The lookup value.
     * @return The list of elements.
     */
    public List<Node> getElementsFromKey(String key, String value) {
        Map<String, List<Node>> index = keyMap.get(key);
        if (index == null) {
            return Collections.emptyList();
        }
        List<Node> matches = index.get(value);
        if (matches == null) {
            return Collections.emptyList();
        }
        return matches;
    }

    /**
     * Build the index for key lookups.
     * 
     * @throws javax.xml.xpath.XPathExpressionException
     *             For errors.
     */
    public void buildIndex() throws XPathExpressionException {
        Element element = getDocumentElement();
        CustomFunctions.setHashcodeMap(indexHashcodes(element));
        Map<String, Map<String, List<Node>>> map = new HashMap<String, Map<String, List<Node>>>();
        indexElement(element, map);
        keyMap = map;
    }

    private Map<String, String> indexHashcodes(Element root) {
        Map<String, String> hashcodeMap = new HashMap<String, String>();
        Set<String> pageIds = new HashSet<String>();
        NodeList words = root.getElementsByTagName("word");
        // Initialize hashcodes for elements with page ids
        for (int i = 0; i < words.getLength(); i++) {
            Element word = (Element) words.item(i);
            String pageId = word.getAttribute("page-id");
            if (pageId.length() > 0) {
                String key = CustomFunctions.hashKey(word.getAttribute("l"), word.getAttribute("v"));
                hashcodeMap.put(key, pageId);
                pageIds.add(pageId);
            }
        }
        // Initialize hashcodes for elements without page ids
        for (int i = 0; i < words.getLength(); i++) {
            Element word = (Element) words.item(i);
            if (word.getAttribute("page-id").length() == 0) {
                String key = CustomFunctions.hashKey(word.getAttribute("l"), word.getAttribute("v"));
                String pageId = CustomFunctions.hashValue(key);
                while (pageIds.contains(pageId)) {
                    pageId = String.valueOf(Long.valueOf(pageId) + 1);
                }
                hashcodeMap.put(key, pageId);
                pageIds.add(pageId);
            }
        }
        return hashcodeMap;
    }

    void indexElement(Element element, Map<String, Map<String, List<Node>>> map)
        throws XPathExpressionException {
        String elementName = element.getNodeName();
        List<Key> keys = ModelConfigManager.instance().getKeys(elementName);
        for (Key key : keys) {
            Map<String, List<Node>> index = map.get(key.getName());
            if (index == null) {
                index = new HashMap<String, List<Node>>();
                map.put(key.getName(), index);
            }
            if (key.getMatch().equals(elementName)) {
                updateIndex(index, element, key, false);
            }
        }
        if (element instanceof ElementImpl) {
            NodeList children = element.getChildNodes();
            for (int i = 0; i < children.getLength(); i++) {
                Element child = (Element) children.item(i);
                indexElement(child, map);
            }
        }
    }

	private void updateIndex(Map<String, List<Node>> index, Element element,
			Key key, boolean sort) throws XPathExpressionException {
		if ("string".equals(key.getType())) {
		    String id = XPathEngine.stringQuery(element, key.getXpath());
		    if (id != null && id.length() > 0) {
		        putInIndex(index, element, id, sort);
		    }
		} else if ("string-list".equals(key.getType())) {
		    String ids = XPathEngine.stringQuery(element, key.getXpath()).trim();
		    if (ids != null && ids.length() > 0) {
		        String[] idList = ids.split(" ");
		        for (String id : idList) {
		            putInIndex(index, element, id, sort);
		        }
		    }
		} else {
		    List<Node> nodes = XPathEngine.query(element, key.getXpath());
		    for (Node node : nodes) {
		        String id = node.getTextContent();
		        if (id != null && id.length() > 0) {
		            putInIndex(index, element, id, sort);
		        }
		    }
		}
	}

	private void putInIndex(Map<String, List<Node>> index, Element element,
			String id, boolean sort) {
		List<Node> list = index.get(id);
		if (list == null) {
		    list = new LinkedList<Node>();
		    index.put(id, list);
		}
		list.add(element);
		if (sort) {
            Collections.sort(list, NODE_COMPARATOR);
		}
	}

    /**
     * Recalculate node positions in document order. Should be called after incorporating new nodes into the DOM, but
     * before re-indexing.
     */
    public void reposition() {
        reposition((ElementBase) getDocumentElement(), 1);
    }

    void reposition(ElementBase element, int position) {
        element.setPosition(position++);
        if (element instanceof ElementImpl) {
            position += element.getAttributes().getLength() * 2;
            NodeList children = element.getChildNodes();
            for (int i = 0; i < children.getLength(); i++) {
                reposition((ElementBase) children.item(i), position);
            }
        } else {
            position++; // For text node
        }
    }

    /**
     * Reindex a given element.
     * 
     * @param element
     *            The element.
     * @throws XPathExpressionException
     *             For errors.
     */
    public void reindex(Element element) throws XPathExpressionException {
        this.elementById.put(element.getAttribute("id"), element);
        String elementName = element.getNodeName();
        List<Key> keys = ModelConfigManager.instance().getKeys(elementName);
        for (Key key : keys) {
            Map<String, List<Node>> index = keyMap.get(key.getName());
            if (index == null) {
                index = new HashMap<String, List<Node>>();
                keyMap.put(key.getName(), index);
            }
            if (key.getMatch().equals(elementName)) {
                updateIndex(index, element, key, true);
            }
        }
    }

    /**
     * Remove the given elements from the index.
     * 
     * @param elements
     *            The elements.
     */
    public void unindex(Element[] elements) {
        for (Map<String, List<Node>> index : keyMap.values()) {
            for (List<Node> list : index.values()) {
                Iterator<Node> i = list.iterator();
                while (i.hasNext()) {
                    Element element = (Element) i.next();
                    for (Element unindex : elements) {
                        if (element == unindex) {
                            i.remove();
                        }
                    }
                }
            }
        }
    }

    @Override
    void addChild(Node child) {
        if (!(childNodes instanceof NodeListMutable)) {
            childNodes = new NodeListMutable();
        }
        ((NodeListMutable) childNodes).add(child);
    }

    @Override
    void fixChildren() {
        if (childNodes instanceof NodeListMutable) {
            childNodes = ((NodeListMutable) childNodes).fixed();
        }
    }

    void setNodeNames(Set<String> nodeNames) {
        this.nodeNames = new HashMap<String, String>(nodeNames.size());
        for (String name : nodeNames) {
            this.nodeNames.put(name, name);
        }
    }

    void setElementById(Map<String, Element> elementById) {
        this.elementById = elementById;
    }

    private static final Comparator<Node> NODE_COMPARATOR = new Comparator<Node>() {
        public int compare(Node o1, Node o2) {
            if (o1.isSameNode(o2)) {
                return 0;
            } else if ((o1.compareDocumentPosition(o2) & Node.DOCUMENT_POSITION_FOLLOWING) > 0) {
                return 1;
            } else {
                return -1;
            }
        }
    };

    @Override
    public int getNodeKind() {
        return Type.DOCUMENT;
    }

    @Override
    public int getDocumentNumber() {
        return documentNumber;
    }

    @Override
    public NodeInfo selectID(String id) {
        return (NodeImpl) getElementById(id);
    }

    @Override
    public Iterator<?> getUnparsedEntityNames() {
        return Collections.EMPTY_LIST.iterator();
    }

    @Override
    public String[] getUnparsedEntity(String name) {
        return null;
    }
}
