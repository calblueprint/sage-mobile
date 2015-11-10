package blueprint.com.sage.checkIn;

import android.os.Bundle;

import com.android.volley.Response;

import java.util.ArrayList;

import blueprint.com.sage.models.APIError;
import blueprint.com.sage.models.CheckIn;
import blueprint.com.sage.network.check_ins.CheckInListRequest;
import blueprint.com.sage.network.check_ins.DeleteCheckInRequest;
import blueprint.com.sage.network.check_ins.VerifyCheckInRequest;
import blueprint.com.sage.shared.NavigationAbstractActivity;

/**
 * Created by charlesx on 11/10/15.
 */
public class CheckInListActivity extends NavigationAbstractActivity {


    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        makeCheckInListRequest();
    }

    public void makeCheckInListRequest() {
        CheckInListRequest request = new CheckInListRequest(this,
            new Response.Listener<ArrayList<CheckIn>>() {
                @Override
                public void onResponse(ArrayList<CheckIn> checkIns) {

                }
            },
            new Response.Listener<APIError>() {
                @Override
                public void onResponse(APIError error) {

            }
        });

        getNetworkManager().getRequestQueue().add(request);
    }

    public void makeDeleteCheckInRequest(CheckIn checkIn) {
        DeleteCheckInRequest request = new DeleteCheckInRequest(this, checkIn,
                new Response.Listener<CheckIn>() {
                    @Override
                    public void onResponse(CheckIn checkIn) {

                    }
                },
                new Response.Listener<APIError>() {
                    @Override
                    public void onResponse(APIError error) {

                    }
                });

        getNetworkManager().getRequestQueue().add(request);
    }

    public void makeVerifyCheckInRequest(CheckIn checkIn) {
        VerifyCheckInRequest request = new VerifyCheckInRequest(this, checkIn,
                new Response.Listener<CheckIn>() {
                    @Override
                    public void onResponse(CheckIn checkIn) {

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
