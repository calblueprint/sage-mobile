package blueprint.com.sage.main.filters;

import android.widget.RadioButton;

import blueprint.com.sage.models.School;
import blueprint.com.sage.shared.filters.Filter;

/**
 * Created by charlesx on 3/10/16.
 */
public class AnnouncementsMySchoolFilter extends Filter {

    private School mSchool;

    public AnnouncementsMySchoolFilter(RadioButton radioButton, School school) {
        super(radioButton);
        mSchool = school;
    }

    public String getFilterKey() {
        return "school_id";
    }

    public String getFilterValue() {
        return "" + mSchool.getId();
    }
}
