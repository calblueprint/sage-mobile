package blueprint.com.sage.admin.requests.filters;

import android.widget.RadioButton;

import blueprint.com.sage.models.School;
import blueprint.com.sage.shared.filters.Filter;

/**
 * Created by charlesx on 4/2/16.
 */
public class CheckInMySchoolFilter extends Filter {

    private School mSchool;

    public CheckInMySchoolFilter(RadioButton radioButton, School school) {
        super(radioButton);
        mSchool = school;
    }

    public String getFilterKey() { return "school_id"; }
    public String getFilterValue() { return "" + mSchool.getId(); }
}
