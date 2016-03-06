package blueprint.com.sage.shared.filters;

import java.util.HashMap;

/**
 * Created by charlesx on 3/6/16.
 */
public abstract class Filter {
    public abstract HashMap<String, String> getQueryParams();
    public abstract void resetFilters();
}
