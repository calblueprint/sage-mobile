package blueprint.com.sage.main.filters;

import android.widget.RadioButton;

import blueprint.com.sage.shared.filters.Filter;

/**
 * Created by charlesx on 3/8/16.
 */
public class AnnouncementsAllFilter extends Filter {

    public AnnouncementsAllFilter(RadioButton radioButton) {
        super(radioButton);
    }

    public String getFilterKey() {
        return "";
    }

    public String getFilterValue() {
        return "";
    }
}
