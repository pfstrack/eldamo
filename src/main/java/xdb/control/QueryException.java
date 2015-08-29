package xdb.control;

/**
 * Exception for query errors.
 * 
 * @author Paul Strack
 */
@SuppressWarnings("serial")
public class QueryException extends Exception {

    /**
     * Constructor.
     * 
     * @param message
     *            The error message.
     * @param rootCause
     *            The true cause of the exception.
     */
    public QueryException(String message, Exception rootCause) {
        super(message, rootCause);
    }
}
