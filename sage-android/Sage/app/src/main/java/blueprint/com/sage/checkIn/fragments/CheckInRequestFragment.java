package blueprint.com.sage.checkIn.fragments;

import android.content.SharedPreferences;
import android.os.Bundle;
import android.view.LayoutInflater;
import android.view.Menu;
import android.view.MenuInflater;
import android.view.MenuItem;
import android.view.View;
import android.view.ViewGroup;
import android.widget.EditText;
import android.widget.TextView;

import com.android.volley.Response;

import blueprint.com.sage.R;
import blueprint.com.sage.models.APIError;
import blueprint.com.sage.models.CheckIn;
import blueprint.com.sage.models.School;
import blueprint.com.sage.models.User;
import blueprint.com.sage.network.check_ins.CreateCheckInRequest;
import butterknife.Bind;
import butterknife.ButterKnife;
import butterknife.OnClick;

/**
 * Created by charlesx on 10/27/15.
 * Fragment to make a checkin request.
 */
public class CheckInRequestFragment extends CheckInAbstractFragment {

    @Bind(R.id.check_in_request_start_field) TextView mStartTime;
    @Bind(R.id.check_in_request_end_field) TextView mEndTime;
    @Bind(R.id.check_in_request_total_field) TextView mTotalTime;
    @Bind(R.id.check_in_request_comments_field) EditText mComments;

    public static CheckInRequestFragment newInstance() { return new CheckInRequestFragment(); }

    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setHasOptionsMenu(true);
    }

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup parent, Bundle savedInstanceState) {
        super.onCreateView(inflater, parent, savedInstanceState);
        View view = inflater.inflate(R.layout.fragment_check_in_request, parent, false);
        ButterKnife.bind(this, view);
        initializeViews();
        return view;
    }

    @Override
    public void onCreateOptionsMenu(Menu menu, MenuInflater inflater) {
        menu.clear();
        inflater.inflate(R.menu.menu_save, menu);
        super.onCreateOptionsMenu(menu, inflater);
    }

    @Override
    public boolean onOptionsItemSelected(MenuItem item) {
        switch (item.getItemId()) {
            case R.id.menu_save:
                validateAndSubmitRequest();
            default:
                return super.onOptionsItemSelected(item);
        }
    }

    private void initializeViews() {
        if (hasPreviousRequest()) {
            
        }
    }

    @OnClick({ R.id.check_in_request_start_field, R.id.check_in_request_end_field})
    private void onStartFieldClick(TextView textView) {
        if (hasPreviousRequest()) return;
    }



    private boolean hasPreviousRequest() {
        SharedPreferences preferences = getParentActivity().getSharedPreferences();
        return preferences.contains(getString(R.string.check_in_start_time)) &&
               preferences.contains(getString(R.string.check_in_end_time));
    }

    private void validateAndSubmitRequest() {
        String start = mStartTime.getText().toString();
        String end = mEndTime.getText().toString();
        User user = getParentActivity().getUser();
        School school = getParentActivity().getSchool();

        boolean isValid = true;



        if (!isValid)
            return;

        CheckIn checkIn = new CheckIn(start, end, user, school);
        createCheckInRequest(checkIn);
    }

    private void createCheckInRequest(CheckIn checkIn) {
        CreateCheckInRequest request = new CreateCheckInRequest(getParentActivity(), checkIn,
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

        getParentActivity().getNetworkManager().getRequestQueue().add(request);
    }
}
