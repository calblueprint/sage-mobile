package blueprint.com.sage.admin.requests.filters;

import android.widget.RadioButton;

import blueprint.com.sage.shared.filters.Filter;

/**
 * Created by charlesx on 4/1/16.
 */
public class CheckInAllFilter extends Filter {

    public CheckInAllFilter(RadioButton radioButton) { super(radioButton); }

    public String getFilterKey() { return ""; }

    public String getFilterValue() { return ""; }
}
