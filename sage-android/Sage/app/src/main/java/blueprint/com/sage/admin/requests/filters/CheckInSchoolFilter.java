package blueprint.com.sage.admin.requests.filters;

import android.widget.RadioButton;
import android.widget.Spinner;

import blueprint.com.sage.models.School;
import blueprint.com.sage.shared.filters.Filter;

/**
 * Created by charlesx on 4/1/16.
 */
public class CheckInSchoolFilter extends Filter {

    private Spinner mSchoolSpinner;

    public CheckInSchoolFilter(RadioButton radioButton, Spinner schoolSpinner) {
        super(radioButton);
        mSchoolSpinner = schoolSpinner;
    }

    public String getFilterKey() { return "school_id"; }

    public String getFilterValue() {
        School school = (School) mSchoolSpinner.getSelectedItem();
        return "" + school.getId();
    }
}
