package xdb.dom.impl;

import java.util.ArrayList;
import java.util.Collections;
import java.util.List;
import net.sf.saxon.Configuration;
import net.sf.saxon.event.Receiver;
import net.sf.saxon.om.Axis;
import net.sf.saxon.om.AxisIterator;
import net.sf.saxon.om.AxisIteratorImpl;
import net.sf.saxon.om.DocumentInfo;
import net.sf.saxon.om.EmptyIterator;
import net.sf.saxon.om.FastStringBuffer;
import net.sf.saxon.om.Item;
import net.sf.saxon.om.LookaheadIterator;
import net.sf.saxon.om.NamePool;
import net.sf.saxon.om.NamespaceIterator;
import net.sf.saxon.om.Navigator;
import net.sf.saxon.om.NodeInfo;
import net.sf.saxon.om.SequenceIterator;
import net.sf.saxon.om.SiblingCountingNode;
import net.sf.saxon.om.SingleNodeIterator;
import net.sf.saxon.om.SingletonIterator;
import net.sf.saxon.om.StandardNames;
import net.sf.saxon.pattern.NameTest;
import net.sf.saxon.pattern.NodeTest;
import net.sf.saxon.trans.XPathException;
import net.sf.saxon.type.Type;
import net.sf.saxon.value.AtomicValue;
import net.sf.saxon.value.UntypedAtomicValue;
import net.sf.saxon.value.Value;
import org.w3c.dom.DOMException;
import org.w3c.dom.Document;
import org.w3c.dom.NamedNodeMap;
import org.w3c.dom.Node;
import org.w3c.dom.NodeList;
import org.w3c.dom.UserDataHandler;

import xdb.util.XmlUtil;


/**
 * Implementation of Node superclass.
 */
public abstract class NodeImpl implements Node, SiblingCountingNode, NodeInfo {
    public static final int POSITION_DISCONNECTED = Node.DOCUMENT_POSITION_DISCONNECTED
        + Node.DOCUMENT_POSITION_IMPLEMENTATION_SPECIFIC;
    private static final int FINGERPRINT_MASK = 1048575;

    private int position;

    /**
     * Constructor.
     * 
     * @param position
     *            Node position within document.
     */
    public NodeImpl(int position) {
        this.position = position;
    }

    @Override
    public Node appendChild(Node newChild) throws DOMException {
        throw DOMImplementationImpl.noModErr();
    }

    @Override
    public Node cloneNode(boolean deep) {
        throw DOMImplementationImpl.notSupportedErr();
    }

    @Override
    public short compareDocumentPosition(Node other) throws DOMException {
        if (this.isSameNode(other)) {
            return 0;
        }
        if (!(other instanceof NodeImpl)) {
            return POSITION_DISCONNECTED;
        }
        NodeImpl otherImpl = (NodeImpl) other;
        if (!(otherImpl.getThisDocument() == this.getThisDocument())) {
            return POSITION_DISCONNECTED;
        }
        short comparison = 0;
        if (this.getPosition() < otherImpl.getPosition()) {
            comparison += Node.DOCUMENT_POSITION_FOLLOWING;
            if (otherImpl.containedBy(this)) {
                comparison += Node.DOCUMENT_POSITION_CONTAINED_BY;
            }
        } else {
            comparison += Node.DOCUMENT_POSITION_PRECEDING;
            if (this.containedBy(otherImpl)) {
                comparison += Node.DOCUMENT_POSITION_CONTAINS;
            }
        }
        return comparison;
    }

    @Override
    public NamedNodeMap getAttributes() {
        return null;
    }

    @Override
    public String getBaseURI() {
        return null;
    }

    @Override
    public Object getFeature(String feature, String version) {
        return null;
    }

    @Override
    public Node getFirstChild() {
        NodeList children = getChildNodes();
        if (children.getLength() == 0) {
            return null;
        }
        return children.item(0);
    }

    @Override
    public Node getLastChild() {
        NodeList children = getChildNodes();
        if (children.getLength() == 0) {
            return null;
        }
        return children.item(children.getLength() - 1);
    }

    @Override
    public String getLocalName() {
        return getNodeName();
    }

    @Override
    public String getNamespaceURI() {
        return null;
    }

    @Override
    public Document getOwnerDocument() {
        Node ancestor = getParentNode();
        if (ancestor == null) {
            return null;
        }
        while (ancestor.getParentNode() != null) {
            ancestor = ancestor.getParentNode();
        }
        return (Document) ancestor;
    }

    @Override
    public String getPrefix() {
        return null;
    }

    @Override
    public Object getUserData(String key) {
        return null;
    }

    @Override
    public boolean hasAttributes() {
        return false;
    }

    @Override
    public Node insertBefore(Node newChild, Node refChild) throws DOMException {
        throw DOMImplementationImpl.noModErr();
    }

    @Override
    public boolean isDefaultNamespace(String namespaceURI) {
        return false;
    }

    @Override
    public boolean isEqualNode(Node other) {
        if (other == null) {
            return false;
        }
        if (other.isSameNode(this)) {
            return true;
        }
        if (other.getNodeType() != this.getNodeType()) {
            return false;
        }
        if (!equalStrings(other.getNodeName(), this.getNodeName())) {
            return false;
        }
        if (!equalStrings(other.getLocalName(), this.getLocalName())) {
            return false;
        }
        if (!equalStrings(other.getNamespaceURI(), this.getNamespaceURI())) {
            return false;
        }
        if (!equalStrings(other.getPrefix(), this.getPrefix())) {
            return false;
        }
        if (!equalStrings(other.getNodeValue(), this.getNodeValue())) {
            return false;
        }
        if (other.getAttributes() == null) {
            if (this.getAttributes() != null) {
                return false;
            }
        } else {
            NamedNodeMap otherAtts = other.getAttributes();
            NamedNodeMap thisAtts = this.getAttributes();
            if (thisAtts == null) {
                return false;
            }
            if (otherAtts.getLength() != thisAtts.getLength()) {
                return false;
            }
            for (int i = 0; i < otherAtts.getLength(); i++) {
                Node otherAtt = otherAtts.item(i);
                if (otherAtt.getNamespaceURI() != null) {
                    return false; // TS-DOM is no-namespace
                }
                Node thisAtt = thisAtts.getNamedItem(otherAtt.getNodeName());
                if (!otherAtt.isEqualNode(thisAtt)) {
                    return false;
                }
            }
        }
        if (other.getChildNodes() == null) {
            if (this.getChildNodes() != null) {
                return false;
            }
        } else {
            NodeList otherChildren = other.getChildNodes();
            NodeList thisChildren = this.getChildNodes();
            if (thisChildren == null) {
                return false;
            }
            if (otherChildren.getLength() != thisChildren.getLength()) {
                return false;
            }
            for (int i = 0; i < otherChildren.getLength(); i++) {
                Node otherChild = otherChildren.item(i);
                Node thisChild = thisChildren.item(i);
                if (!otherChild.isEqualNode(thisChild)) {
                    return false;
                }
            }
        }
        return true;
    }

    static boolean equalStrings(String x, String y) {
        if (x == null) {
            return y == null;
        } else {
            return x.equals(y);
        }
    }

    @Override
    public boolean isSameNode(Node other) {
        return other == this;
    }

    @Override
    public boolean isSupported(String feature, String version) {
        return false;
    }

    @Override
    public String lookupNamespaceURI(String prefix) {
        return null;
    }

    @Override
    public String lookupPrefix(String namespaceURI) {
        return null;
    }

    @Override
    public void normalize() {
    }

    @Override
    public Node removeChild(Node oldChild) throws DOMException {
        throw DOMImplementationImpl.noModErr();
    }

    @Override
    public Node replaceChild(Node newChild, Node oldChild) throws DOMException {
        throw DOMImplementationImpl.noModErr();
    }

    @Override
    public void setNodeValue(String nodeValue) throws DOMException {
        throw DOMImplementationImpl.noModErr();
    }

    @Override
    public void setPrefix(String prefix) throws DOMException {
        throw DOMImplementationImpl.noModErr();
    }

    @Override
    public void setTextContent(String textContent) throws DOMException {
        throw DOMImplementationImpl.noModErr();
    }

    @Override
    public Object setUserData(String key, Object data, UserDataHandler handler) {
        return null;
    }

    @Override
    public String toString() {
        return getTextContent();
    }

    DocumentImpl getThisDocument() {
        DocumentImpl doc = (DocumentImpl) getOwnerDocument();
        if (doc == null) {
            doc = (DocumentImpl) this;
        }
        return doc;
    }

    void addChild(Node child) {
        throw new UnsupportedOperationException();
    }

    void fixChildren() {
        throw new UnsupportedOperationException();
    }

    int getPosition() {
        return this.position;
    }

    void setPosition(int position) {
        this.position = position;
    }

    boolean containedBy(NodeImpl other) {
        Node parent = getParentNode();
        while (parent != null) {
            if (other.isSameNode(parent)) {
                return true;
            }
            parent = parent.getParentNode();
        }
        return false;
    }

    @Override
    public boolean isSameNodeInfo(NodeInfo other) {
        if (!(other instanceof NodeImpl)) {
            return false;
        }
        return isSameNode((NodeImpl) other);
    }

    @Override
    public String getSystemId() {
        return null;
    }

    @Override
    public int getLineNumber() {
        return -1;
    }

    @Override
    public int getColumnNumber() {
        return -1;
    }

    @Override
    public int compareOrder(NodeInfo other) {
        if (this.isSameNodeInfo(other)) {
            return 0;
        }
        if (!(other instanceof NodeImpl)) {
            return -1;
        }
        NodeImpl otherImpl = (NodeImpl) other;
        if (this.getPosition() < otherImpl.getPosition()) {
            return -1;
        } else {
            return 1;
        }
    }

    @Override
    public String getStringValue() {
        return getTextContent();
    }

    @Override
    public int getNameCode() {
        return -1;
    }

    @Override
    public int getFingerprint() {
        int nc = getNameCode();
        if (nc == -1) {
            return -1;
        }
        return nc & FINGERPRINT_MASK;
    }

    @Override
    public String getLocalPart() {
        int nodeKind = getNodeKind();
        if (nodeKind == Type.ELEMENT || nodeKind == Type.ATTRIBUTE) {
            return getLocalName();
        } else {
            return null;
        }
    }

    @Override
    public String getURI() {
        return "";
    }

    @Override
    public String getDisplayName() {
        int nodeKind = getNodeKind();
        if (nodeKind == Type.ELEMENT || nodeKind == Type.ATTRIBUTE) {
            return getLocalName();
        } else {
            return null;
        }
    }

    @Override
    public Configuration getConfiguration() {
        return XmlUtil.SAXON_CONFIG;
    }

    @Override
    public NamePool getNamePool() {
        return getConfiguration().getNamePool();
    }

    @Override
    public int getTypeAnnotation() {
        if (getNodeKind() == Type.ATTRIBUTE) {
            return StandardNames.XS_UNTYPED_ATOMIC;
        }
        return StandardNames.XS_UNTYPED;
    }

    @Override
    public Value atomize() throws XPathException {
        return new UntypedAtomicValue(getStringValueCS());
    }

    @Override
    public NodeInfo getParent() {
        if (getNodeKind() == Type.ATTRIBUTE) {
            return (NodeImpl) ((AttrImpl) this).getOwnerElement();
        } else {
            return (NodeImpl) getParentNode();
        }
    }

    @Override
    public AxisIterator iterateAxis(byte axisNumber) {
        int nodeKind = getNodeKind();
        switch (axisNumber) {
        case Axis.ANCESTOR:
            if (nodeKind == Type.DOCUMENT) {
                return EmptyIterator.getInstance();
            }
            return new Navigator.AncestorEnumeration(this, false);

        case Axis.ANCESTOR_OR_SELF:
            if (nodeKind == Type.DOCUMENT) {
                return SingleNodeIterator.makeIterator(this);
            }
            return new Navigator.AncestorEnumeration(this, true);

        case Axis.ATTRIBUTE:
            if (nodeKind != Type.ELEMENT) {
                return EmptyIterator.getInstance();
            }
            return new AttributeEnumeration(this);

        case Axis.CHILD:
            if (hasChildNodes()) {
                return new ChildEnumeration(this, true, true, false);
            } else {
                return EmptyIterator.getInstance();
            }

        case Axis.DESCENDANT:
            if (hasChildNodes()) {
                return new Navigator.DescendantEnumeration(this, false, true);
            } else {
                return EmptyIterator.getInstance();
            }

        case Axis.DESCENDANT_OR_SELF:
            return new Navigator.DescendantEnumeration(this, true, true);

        case Axis.FOLLOWING:
            return new Navigator.FollowingEnumeration(this);

        case Axis.FOLLOWING_SIBLING:
            switch (nodeKind) {
            case Type.DOCUMENT:
            case Type.ATTRIBUTE:
            case Type.NAMESPACE:
                return EmptyIterator.getInstance();
            default:
                return new ChildEnumeration(this, false, true, false);
            }

        case Axis.NAMESPACE:
            if (nodeKind != Type.ELEMENT) {
                return EmptyIterator.getInstance();
            }
            return NamespaceIterator.makeIterator(this, null);

        case Axis.PARENT:
            return SingleNodeIterator.makeIterator(getParent());

        case Axis.PRECEDING:
            return new Navigator.PrecedingEnumeration(this, false);

        case Axis.PRECEDING_SIBLING:
            switch (nodeKind) {
            case Type.DOCUMENT:
            case Type.ATTRIBUTE:
            case Type.NAMESPACE:
                return EmptyIterator.getInstance();
            default:
                return new ChildEnumeration(this, false, false, false);
            }

        case Axis.SELF:
            return SingleNodeIterator.makeIterator(this);

        case Axis.PRECEDING_OR_ANCESTOR:
            return new Navigator.PrecedingEnumeration(this, true);

        default:
            throw new IllegalArgumentException("Unknown axis number " + axisNumber);
        }
    }

    @Override
    public AxisIterator iterateAxis(byte axisNumber, NodeTest nodeTest) {
        if (axisNumber == Axis.CHILD && nodeTest.getPrimitiveType() == Type.ELEMENT) {
            if (hasChildNodes()) {
                return new Navigator.AxisFilter(new ChildEnumeration(this, true, true, true),
                    nodeTest);
            } else {
                return EmptyIterator.getInstance();
            }
        }
        return new Navigator.AxisFilter(iterateAxis(axisNumber), nodeTest);
    }

    @Override
    public String getAttributeValue(int fingerprint) {
        // TODO: Optimize
        NameTest test = new NameTest(Type.ATTRIBUTE, fingerprint, getNamePool());
        AxisIterator iterator = iterateAxis(Axis.ATTRIBUTE, test);
        NodeInfo attribute = (NodeInfo) iterator.next();
        if (attribute == null) {
            return null;
        } else {
            return attribute.getStringValue();
        }
    }

    @Override
    public NodeInfo getRoot() {
        return getDocumentRoot();
    }

    @Override
    public DocumentInfo getDocumentRoot() {
        if (this instanceof DocumentImpl) {
            return (DocumentImpl) this;
        }
        return (DocumentImpl) getOwnerDocument();
    }

    @Override
    public void generateId(FastStringBuffer buffer) {
        Navigator.appendSequentialKey(this, buffer, true);
    }

    @Override
    public int getDocumentNumber() {
        return getDocumentRoot().getDocumentNumber();
    }

    @Override
    public void copy(Receiver out, int whichNamespaces, boolean copyAnnotations, int locationId)
        throws XPathException {
        Navigator.copy(this, out, getDocumentRoot().getNamePool(), whichNamespaces,
            copyAnnotations, locationId);
    }

    private static final int[] EMPTY_INT_ARRAY = new int[0];

    @Override
    public int[] getDeclaredNamespaces(int[] buffer) {
        if (getNodeType() == Node.ELEMENT_NODE) {
            return EMPTY_INT_ARRAY;
        } else {
            return null;
        }
    }

    @Override
    public boolean isId() {
        return false;
    }

    @Override
    public boolean isIdref() {
        return false;
    }

    @Override
    public boolean isNilled() {
        return false;
    }

    @Override
    public void setSystemId(String uri) {
        // No op
    }

    @Override
    public CharSequence getStringValueCS() {
        return getStringValue();
    }

    @Override
    public SequenceIterator getTypedValue() throws XPathException {
        return SingletonIterator.makeIterator((AtomicValue) atomize());
    }

    @Override
    public int getSiblingPosition() {
        // TODO: Better optimization
        int nodeKind = getNodeKind();
        switch (nodeKind) {
        case Type.ELEMENT:
            int ix = 0;
            Node start = this;
            while (true) {
                start = start.getPreviousSibling();
                if (start == null) {
                    return ix;
                }
                ix++;
            }
        case Type.ATTRIBUTE:
            ix = 0;
            int fp = getFingerprint();
            AxisIterator iter = getParent().iterateAxis(Axis.ATTRIBUTE);
            while (true) {
                NodeInfo n = (NodeInfo) iter.next();
                if (n == null || n.getFingerprint() == fp) {
                    return ix;
                }
                ix++;
            }
        default:
            return 0;
        }
    }

    private final class AttributeEnumeration implements AxisIterator, LookaheadIterator {

        private final List<AttrImpl> attributes;
        private int index = 0;
        private final NodeImpl node;
        private NodeImpl current;

        public AttributeEnumeration(NodeImpl node) {
            this.node = node;
            NamedNodeMap attMap = node.getAttributes();
            if (attMap != null) {
                final int length = attMap.getLength();
                attributes = new ArrayList<AttrImpl>(length);
                for (int i = 0; i < length; i++) {
                    attributes.add((AttrImpl) attMap.item(i));
                }
            } else {
                attributes = Collections.emptyList();
            }
            index = 0;
        }

        public boolean hasNext() {
            return index < attributes.size();
        }

        public boolean moveNext() {
            return (next() != null);
        }

        public Item next() {
            if (index >= attributes.size()) {
                return null;
            }
            current = attributes.get(index);
            index++;
            return current;
        }

        public Item current() {
            return current;
        }

        public int position() {
            return index + 1;
        }

        public void close() {
        }

        public AxisIterator iterateAxis(byte axis, NodeTest test) {
            return current.iterateAxis(axis, test);
        }

        public Value atomize() throws XPathException {
            return current.atomize();
        }

        public CharSequence getStringValue() {
            return current.getStringValueCS();
        }

        public SequenceIterator getAnother() {
            return new AttributeEnumeration(node);
        }

        public int getProperties() {
            return LOOKAHEAD;
        }
    }

    private final class ChildEnumeration extends AxisIteratorImpl implements LookaheadIterator {

        private NodeImpl node;
        private NodeImpl commonParent;
        private boolean downwards;
        private boolean forwards;
        private boolean elementsOnly;
        private NodeList childNodes;
        private int length;
        private int index;

        public ChildEnumeration(NodeImpl node, boolean downwards, boolean forwards,
            boolean elementsOnly) {
            this.node = node;
            this.downwards = downwards;
            this.forwards = forwards;
            this.elementsOnly = elementsOnly;
            position = 0;

            if (downwards) {
                commonParent = node;
            } else {
                commonParent = (NodeImpl) node.getParent();
            }

            childNodes = commonParent.getChildNodes();
            length = childNodes.getLength();
            if (downwards) {
                if (forwards) {
                    index = -1;
                } else {
                    index = length;
                }
            } else {
                index = node.getSiblingPosition();
            }
        }

        public boolean hasNext() {
            if (forwards) {
                return index + 1 < length;
            } else {
                return index > 0;
            }
        }

        public Item next() {
            while (true) {
                if (forwards) {
                    index += 1;
                    if (index >= length) {
                        return null;
                    } else {
                        Node currentDomNode = childNodes.item(index);
                        switch (currentDomNode.getNodeType()) {
                        case Node.ELEMENT_NODE:
                            break;
                        default:
                            if (elementsOnly) {
                                continue;
                            } else {
                                break;
                            }
                        }
                        current = (NodeImpl) currentDomNode;
                        return current;
                    }
                } else {
                    index--;
                    if (index < 0) {
                        return null;
                    } else {
                        index -= (1 - 1);
                        Node currentDomNode = childNodes.item(index);
                        switch (currentDomNode.getNodeType()) {
                        case Node.ELEMENT_NODE:
                            break;
                        default:
                            if (elementsOnly) {
                                continue;
                            } else {
                                break;
                            }
                        }
                        current = (NodeImpl) currentDomNode;
                        return current;
                    }
                }
            }
        }

        public SequenceIterator getAnother() {
            return new ChildEnumeration(node, downwards, forwards, elementsOnly);
        }

        @Override
        public int getProperties() {
            return LOOKAHEAD;
        }
    }
}
