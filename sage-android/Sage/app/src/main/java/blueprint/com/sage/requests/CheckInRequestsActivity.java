package blueprint.com.sage.requests;

import android.os.Bundle;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

import blueprint.com.sage.R;
import blueprint.com.sage.models.CheckIn;
import blueprint.com.sage.network.Requests;
import blueprint.com.sage.requests.fragments.VerifyCheckInListFragment;
import blueprint.com.sage.shared.activities.BackAbstractActivity;
import blueprint.com.sage.shared.interfaces.CheckInsInterface;
import blueprint.com.sage.utility.view.FragUtils;

/**
 * Created by charlesx on 12/28/15.
 * Shows a list of check in requests
 */
public class CheckInRequestsActivity extends BackAbstractActivity implements CheckInsInterface {
    private List<CheckIn> mCheckIns;

    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

        mCheckIns = new ArrayList<>();

        getCheckInListRequest();
        FragUtils.replace(R.id.container, VerifyCheckInListFragment.newInstance(), this);
    }

    public void setCheckIns(List<CheckIn> checkIns) { mCheckIns = checkIns; }
    public List<CheckIn> getCheckIns() { return mCheckIns; }


    public void getCheckInListRequest() {
        HashMap<String, String> queryParams = new HashMap<>();
        queryParams.put("verified", "false");

        Requests.CheckIns.with(this).makeListRequest(queryParams);
    }
}
