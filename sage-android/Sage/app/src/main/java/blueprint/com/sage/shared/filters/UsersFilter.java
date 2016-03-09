package blueprint.com.sage.shared.filters;

/**
 * Created by charlesx on 3/6/16.
 */
public class UsersFilter extends FilterController {

    public UsersFilter() { super(); }

    public void onFilter() {}

    public void addSchoolFilter(int schoolId) {
        mQueryParams.put("school_id", "" + schoolId);
    }

    public void addVerfiedFilter(boolean verified) {
        int verifiedInt = verified ? 1 : 0;
        mQueryParams.put("verified", "" + verifiedInt);
    }
}
