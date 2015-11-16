package blueprint.com.sage.schools;

import android.os.Bundle;

import java.util.ArrayList;
import java.util.List;

import blueprint.com.sage.R;
import blueprint.com.sage.models.School;
import blueprint.com.sage.network.Requests;
import blueprint.com.sage.schools.fragments.SchoolListFragment;
import blueprint.com.sage.shared.activities.NavigationAbstractActivity;
import blueprint.com.sage.utility.view.FragUtils;

/**
 * Created by charlesx on 11/4/15.
 */
public class SchoolsListActivity extends NavigationAbstractActivity {

    private List<School> mSchools;

    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

        mSchools = new ArrayList<>();

        getSchoolsListRequest();
        FragUtils.replace(R.id.container, SchoolListFragment.newInstance(), this);
    }

    public void getSchoolsListRequest() {
        Requests.Schools.with(this).makeListRequest(null);
    }

    public void setSchools(List<School> schools) { mSchools = schools; }
    public List<School> getSchools() { return mSchools; }
}
