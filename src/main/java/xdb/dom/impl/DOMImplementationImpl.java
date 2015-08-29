package xdb.dom.impl;



import org.w3c.dom.DOMException;
import org.w3c.dom.DOMImplementation;
import org.w3c.dom.Document;
import org.w3c.dom.DocumentType;



/**
 * Implementation of the DOMImplementation class.
 */
public class DOMImplementationImpl implements DOMImplementation {
    @Override
    public Document createDocument(String namespaceURI, String qualifiedName, DocumentType doctype)
        throws DOMException {
        throw notSupportedErr();
    }

    @Override
    public DocumentType createDocumentType(String qualifiedName, String publicId, String systemId)
        throws DOMException {
        throw notSupportedErr();
    }

    @Override
    public Object getFeature(String feature, String version) {
        return null;
    }

    @Override
    public boolean hasFeature(String feature, String version) {
        return false;
    }

    /**
     * Stock NO_MODIFICATION_ALLOWED_ERR.
     * 
     * @return Stock NO_MODIFICATION_ALLOWED_ERR.
     */
    public static DOMException noModErr() {
        return new DOMException(DOMException.NO_MODIFICATION_ALLOWED_ERR, "Read only");
    }

    /**
     * Stock HIERARCHY_REQUEST_ERR.
     * 
     * @return Stock HIERARCHY_REQUEST_ERR
     */
    public static DOMException hierarchyRequestErr() {
        return new DOMException(DOMException.HIERARCHY_REQUEST_ERR, "Hierarchy problems");
    }

    /**
     * Stock NOT_SUPPORTED_ERR.
     * 
     * @return Stock NOT_SUPPORTED_ERR
     */
    public static DOMException notSupportedErr() {
        return new DOMException(DOMException.NOT_SUPPORTED_ERR, "Not supported");
    }

    /**
     * Stock error for imports of nodes from other parsers.
     * 
     * @return Stock error for imports of nodes from other parsers.
     */
    public static DOMException badImportErr() {
        String msg = "Only deep imports of xdb.dom.impl elements allowed";
        return new DOMException(DOMException.NOT_SUPPORTED_ERR, msg);
    }
}
