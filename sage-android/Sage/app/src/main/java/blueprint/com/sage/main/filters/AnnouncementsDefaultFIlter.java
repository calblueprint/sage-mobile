package blueprint.com.sage.main.filters;

import android.widget.RadioButton;

import blueprint.com.sage.models.School;
import blueprint.com.sage.shared.filters.Filter;

/**
 * Created by charlesx on 3/8/16.
 */
public class AnnouncementsDefaultFilter extends Filter {

    private School mSchool;

    public AnnouncementsDefaultFilter(RadioButton radioButton, School school) {
        super(radioButton);
        mSchool = school;
    }

    public String getFilterKey() {
        return "default";
    }

    public String getFilterValue() {
        return "" + mSchool.getId();
    }
}
