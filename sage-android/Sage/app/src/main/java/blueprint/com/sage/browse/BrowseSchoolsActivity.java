package blueprint.com.sage.browse;

import android.os.Bundle;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

import blueprint.com.sage.R;
import blueprint.com.sage.browse.fragments.SchoolListFragment;
import blueprint.com.sage.models.School;
import blueprint.com.sage.network.Requests;
import blueprint.com.sage.shared.activities.BackAbstractActivity;
import blueprint.com.sage.shared.interfaces.SchoolsInterface;
import blueprint.com.sage.utility.view.FragUtils;

/**
 * Created by charlesx on 12/28/15.
 * Shows a list of schools
 */
public class BrowseSchoolsActivity extends BackAbstractActivity implements SchoolsInterface {

    private List<School> mSchools;

    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        mSchools = new ArrayList<>();
        FragUtils.replace(R.id.container, SchoolListFragment.newInstance(), this);
    }

    public void getSchoolsListRequest() {
        HashMap<String, String> queryParams = new HashMap<>();
        queryParams.put("sort[attr]", "lower(name)");
        queryParams.put("sort[order]", "asc");
        Requests.Schools.with(this).makeListRequest(queryParams);
    }

    public void setSchools(List<School> schools) { mSchools = schools; }
    public List<School> getSchools() { return mSchools; }
}
