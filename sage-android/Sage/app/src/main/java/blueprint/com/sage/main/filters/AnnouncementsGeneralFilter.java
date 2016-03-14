package blueprint.com.sage.main.filters;

import android.widget.RadioButton;

import blueprint.com.sage.shared.filters.Filter;

/**
 * Created by charlesx on 3/8/16.
 */
public class AnnouncementsGeneralFilter extends Filter {

    public AnnouncementsGeneralFilter(RadioButton generalRadioButton) {
        super(generalRadioButton);
    }

    public String getFilterKey() {
        return "category";
    }

    public String getFilterValue() {
        return "1";
    }
}
