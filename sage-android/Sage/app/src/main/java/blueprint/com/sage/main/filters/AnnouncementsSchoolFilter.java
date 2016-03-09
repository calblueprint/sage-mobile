package blueprint.com.sage.main.filters;

import android.widget.RadioButton;
import android.widget.Spinner;

import blueprint.com.sage.models.School;
import blueprint.com.sage.shared.filters.Filter;

/**
 * Created by charlesx on 3/8/16.
 */
public class AnnouncementsSchoolFilter extends Filter {

    private Spinner mSchoolSpinner;

    public AnnouncementsSchoolFilter(RadioButton schoolRadioButton, Spinner schoolSpinner) {
        super(schoolRadioButton);
        mSchoolSpinner = schoolSpinner;
    }

    public String getFilterKey() {
        return "school_id";
    }

    public String getFilterValue() {
        School school = (School) mSchoolSpinner.getSelectedItem();
        return "" + school.getId();
    }
}
