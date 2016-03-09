package blueprint.com.sage.shared.filters;

/**
 * Created by charlesx on 3/6/16.
 */
public class CheckInsFilter extends FilterController {

    public CheckInsFilter() { super(); }

    public void onFilter() {}

    public void addAllFilter() {
        resetFilters();
    }

    public void addVerifiedFilter(boolean verified) {
        int verifiedInt = verified ? 1 : 0;
        mQueryParams.put("verified", "" + verifiedInt);
    }

    public void addSchoolFilter(int schoolId) {
        mQueryParams.put("school_id", "" + schoolId);
    }

    public void addUserFilter(int userId) {
        mQueryParams.put("user_id", "" + userId);
    }
}
