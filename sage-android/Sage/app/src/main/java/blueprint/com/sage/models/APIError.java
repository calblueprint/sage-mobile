package blueprint.com.sage.models;

/**
 * Created by kelseylam on 10/14/15.
 */
public class APIError {
    private String mMessage;

    public APIError() {
        mMessage = "An error has occurred.";
    }

    // Getters
    public String getMessage() { return mMessage; }

    // Setters
    public void setMessage(String message) { mMessage = message; }
}
