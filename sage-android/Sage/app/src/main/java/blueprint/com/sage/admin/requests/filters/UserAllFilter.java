package blueprint.com.sage.admin.requests.filters;

import android.widget.RadioButton;

import blueprint.com.sage.shared.filters.Filter;

/**
 * Created by charlesx on 4/4/16.
 */
public class UserAllFilter extends Filter {

    public UserAllFilter(RadioButton radioButton) {
        super(radioButton);
    }

    public String getFilterKey() { return ""; }

    public String getFilterValue() { return ""; }
}
