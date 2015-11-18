package blueprint.com.sage.browse;

import android.os.Bundle;

import com.google.android.gms.common.api.GoogleApiClient;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

import blueprint.com.sage.R;
import blueprint.com.sage.models.School;
import blueprint.com.sage.network.Requests;
import blueprint.com.sage.browse.fragments.SchoolListFragment;
import blueprint.com.sage.shared.activities.NavigationAbstractActivity;
import blueprint.com.sage.utility.view.FragUtils;

/**
 * Created by charlesx on 11/4/15.
 */
public class BrowseActivity extends NavigationAbstractActivity {

    private List<School> mSchools;
    private GoogleApiClient mGoogleApiClient;

    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

        mSchools = new ArrayList<>();

        getSchoolsListRequest();
        getUsersListRequest();
        FragUtils.replace(R.id.container, SchoolListFragment.newInstance(), this);
    }

    public void getSchoolsListRequest() {
        Requests.Schools.with(this).makeListRequest(null);
    }
    public void getUsersListRequest() {
        HashMap<String, String> queryParams = new HashMap<>();
        queryParams.put("verified", "true");

        Requests.Users.with(this).makeListRequest(queryParams);
    }

    public void setSchools(List<School> schools) { mSchools = schools; }
    public List<School> getSchools() { return mSchools; }
}
