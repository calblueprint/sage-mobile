package blueprint.com.sage.admin.requests.filters;

import android.widget.RadioButton;
import android.widget.Spinner;

import blueprint.com.sage.models.School;
import blueprint.com.sage.shared.filters.Filter;

/**
 * Created by charlesx on 4/4/16.
 */
public class UserSchoolFilter extends Filter {

    private Spinner mSpinner;

    public UserSchoolFilter(RadioButton radioButton, Spinner spinner) {
        super(radioButton);
        mSpinner = spinner;
    }

    public String getFilterKey() {
        return "school_id";
    }

    public String getFilterValue() {
        School school = (School) mSpinner.getSelectedItem();
        return "" + school.getId();
    }
}
