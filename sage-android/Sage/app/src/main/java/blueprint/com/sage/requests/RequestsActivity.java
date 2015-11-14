package blueprint.com.sage.requests;

import android.os.Bundle;

import com.android.volley.Response;

import java.util.ArrayList;
import java.util.List;

import blueprint.com.sage.R;
import blueprint.com.sage.events.checkIns.CheckInListEvent;
import blueprint.com.sage.events.checkIns.DeleteCheckInEvent;
import blueprint.com.sage.events.checkIns.VerifyCheckInEvent;
import blueprint.com.sage.models.APIError;
import blueprint.com.sage.models.CheckIn;
import blueprint.com.sage.network.check_ins.CheckInListRequest;
import blueprint.com.sage.network.check_ins.DeleteCheckInRequest;
import blueprint.com.sage.network.check_ins.VerifyCheckInRequest;
import blueprint.com.sage.requests.fragments.CheckInListFragment;
import blueprint.com.sage.shared.activities.NavigationAbstractActivity;
import blueprint.com.sage.utility.view.FragUtils;
import de.greenrobot.event.EventBus;

/**
 * Created by charlesx on 11/10/15.
 */
public class RequestsActivity extends NavigationAbstractActivity {

    private List<CheckIn> mCheckIns;

    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

        mCheckIns = new ArrayList<>();

        makeCheckInListRequest();

        FragUtils.replace(R.id.container, CheckInListFragment.newInstance(), this);
    }

    public void setCheckIns(List<CheckIn> checkIns) {
        mCheckIns = checkIns;
        EventBus.getDefault().post(new CheckInListEvent());
    }
    public List<CheckIn> getCheckIns() { return mCheckIns; }

    public void makeCheckInListRequest() {
        CheckInListRequest request = new CheckInListRequest(this, false,
            new Response.Listener<ArrayList<CheckIn>>() {
                @Override
                public void onResponse(ArrayList<CheckIn> checkIns) {
                    setCheckIns(checkIns);
                }
            },
            new Response.Listener<APIError>() {
                @Override
                public void onResponse(APIError error) {

            }
        });

        getNetworkManager().getRequestQueue().add(request);
    }

    public void makeDeleteCheckInRequest(CheckIn checkIn, final int position) {
        DeleteCheckInRequest request = new DeleteCheckInRequest(this, checkIn,
                new Response.Listener<CheckIn>() {
                    @Override
                    public void onResponse(CheckIn checkIn) {
                        EventBus.getDefault().post(new DeleteCheckInEvent(checkIn, position));
                    }
                },
                new Response.Listener<APIError>() {
                    @Override
                    public void onResponse(APIError error) {

                    }
                });

        getNetworkManager().getRequestQueue().add(request);
    }

    public void makeVerifyCheckInRequest(CheckIn checkIn, final int position) {
        VerifyCheckInRequest request = new VerifyCheckInRequest(this, checkIn,
                new Response.Listener<CheckIn>() {
                    @Override
                    public void onResponse(CheckIn checkIn) {
                        EventBus.getDefault().post(new VerifyCheckInEvent(checkIn, position));
                    }
                },
                new Response.Listener<APIError>() {
                    @Override
                    public void onResponse(APIError error) {

                    }
                });

        getNetworkManager().getRequestQueue().add(request);
    }
}
