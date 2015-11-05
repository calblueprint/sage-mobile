package blueprint.com.sage.schools;

import android.os.Bundle;

import com.android.volley.Response;

import java.util.ArrayList;
import java.util.List;

import blueprint.com.sage.R;
import blueprint.com.sage.models.APIError;
import blueprint.com.sage.models.School;
import blueprint.com.sage.network.schools.SchoolListRequest;
import blueprint.com.sage.schools.fragments.SchoolListFragment;
import blueprint.com.sage.shared.NavigationAbstractActivity;
import blueprint.com.sage.utility.view.FragUtils;

/**
 * Created by charlesx on 11/4/15.
 */
public class SchoolsActivity extends NavigationAbstractActivity {

    private List<School> mSchools;

    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

        mSchools = new ArrayList<>();

        getSchoolsList();
        FragUtils.replace(R.id.check_in_container, SchoolListFragment.newInstance(), this);
    }

    private void getSchoolsList() {
        SchoolListRequest request = new SchoolListRequest(this,
                new Response.Listener<ArrayList<School>>() {
                    @Override
                    public void onResponse(ArrayList<School> schools) {

                    }
                }, new Response.Listener<APIError>() {
                    @Override
                    public void onResponse(APIError error) {
                    }
        });

        getNetworkManager().getRequestQueue().add(request);
    }
}
