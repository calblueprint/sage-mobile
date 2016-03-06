package blueprint.com.sage.shared.filters;

import java.util.HashMap;

/**
 * Created by charlesx on 3/6/16.
 */
public abstract class Filter {

    protected HashMap<String, String> mQueryParams;

    public HashMap<String, String> getQueryParams(HashMap<String, String> queryParams) {
        mQueryParams.putAll(queryParams);
        return mQueryParams;
    }

    public void resetFilters() {
        mQueryParams = new HashMap<>();
    }
}
