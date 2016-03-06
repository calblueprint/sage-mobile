package blueprint.com.sage.shared.filters;

import java.util.HashMap;

/**
 * Created by charlesx on 3/6/16.
 */
public class UsersFilter extends Filter {

    public UsersFilter() {
        mQueryParams = new HashMap<>();
    }

    public void addSchoolFilter(int schoolId) {
        mQueryParams.put("school_id", "" + schoolId);
    }

    public void addVerfiedFilter(boolean verified) {
        int verifiedInt = verified ? 1 : 0;
        mQueryParams.put("verified", "" + verifiedInt);
    }
}
