package blueprint.com.sage.shared.validators;

import android.app.Activity;
import android.support.design.widget.Snackbar;
import android.view.View;
import android.widget.EditText;
import android.widget.Spinner;

import java.util.regex.Pattern;

import blueprint.com.sage.R;

/**
 * Created by charlesx on 11/18/15.
 */
public class FormValidator {

    private Activity mActivity;

    public static final Pattern VALID_EMAIL_ADDRESS_REGEX =
            Pattern.compile("^[a-zA-Z0-9._%+-]+@berkeley\\.edu$", Pattern.CASE_INSENSITIVE);

    private FormValidator(Activity activity) { mActivity = activity; }

    public static FormValidator newInstance(Activity activity) {
        return new FormValidator(activity);
    }

    public boolean hasValidEmail(EditText email) {
        String emailString = email.getText().toString();
        if (!VALID_EMAIL_ADDRESS_REGEX.matcher(emailString).find()) {
            email.setError(mActivity.getString(R.string.email_error));
            return false;
        }
        return true;
    }

    public boolean hasNonBlankField(EditText editText, String error) {
        String field = editText.getText().toString();
        if (field.isEmpty()) {
            editText.setError(mActivity.getString(R.string.cannot_be_blank, error));
            return false;
        }
        return true;
    }

    public boolean hasMatchingPassword(EditText password, EditText confirmPassword) {
        String passwordString = password.getText().toString();
        String confirmPasswordString = confirmPassword.getText().toString();
        if (!passwordString.equals(confirmPasswordString)) {
            password.setError(mActivity.getString(R.string.password_nonmatch_error));
            return false;
        }
        return true;
    }

    public boolean mustBePicked(Spinner spinner, String error, View view) {
        if (spinner.getSelectedItem() == null) {
            Snackbar.make(view, mActivity.getString(R.string.cannot_be_blank, error), Snackbar.LENGTH_SHORT).show();
            return false;
        }
        return true;
    }
}
