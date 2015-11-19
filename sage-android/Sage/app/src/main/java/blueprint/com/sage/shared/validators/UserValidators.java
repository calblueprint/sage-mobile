package blueprint.com.sage.shared.validators;

import android.widget.EditText;

import java.util.regex.Pattern;

/**
 * Created by charlesx on 11/18/15.
 */
public class UserValidators {

    public static final Pattern VALID_EMAIL_ADDRESS_REGEX =
            Pattern.compile("^[a-zA-Z0-9._%+-]+@berkeley\\.edu$", Pattern.CASE_INSENSITIVE);

    public static boolean hasValidEmail(EditText email, String error) {
        String emailString = email.getText().toString();
        if (!VALID_EMAIL_ADDRESS_REGEX.matcher(emailString).find()) {
            email.setText(error);
            return false;
        }
        return true;
    }

    public static boolean hasNonBlankField(EditText editText, String error) {
        String field = editText.getText().toString();
        if (field.isEmpty()) {
            editText.setError(error);
            return false;
        }
        return true;
    }

    public static boolean hasMatchingPassword(EditText password, EditText confirmPassword, String error) {
        String passwordString = password.getText().toString();
        String confirmPasswordString = confirmPassword.getText().toString();
        if (!passwordString.equals(confirmPasswordString)) {
            password.setError(error);
            return false;
        }
        return true;
    }
}
