package blueprint.com.sage.shared.filters;

import java.util.HashMap;

import blueprint.com.sage.shared.interfaces.BaseInterface;

/**
 * Created by charlesx on 3/6/16.
 */
public class AnnouncementsFilter extends Filter {

    private HashMap<String, String> mQueryParams;
    private BaseInterface mBaseInterface;

    public AnnouncementsFilter(BaseInterface baseInterface) {
        mQueryParams = new HashMap<>();
    }

    public void addAllFilter() {
        resetFilters();
    }

    public void addGeneralFilter() {
        mQueryParams.put("category", "1");
    }

    public void addSchoolFilter(int id) {
        mQueryParams.put("school_id", "" + id);
    }

    public void addDefaultFilter(int schoolId) {
        mQueryParams.put("default", "" + schoolId);
    }

    public HashMap<String, String> getQueryParams() {
        return mQueryParams;
    }

    public void resetFilters() {
        mQueryParams = new HashMap<>();
    }
}
