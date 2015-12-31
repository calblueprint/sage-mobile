package blueprint.com.sage.main.fragments;

import android.os.Bundle;
import android.support.v4.app.Fragment;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.LinearLayout;

import blueprint.com.sage.R;
import blueprint.com.sage.browse.BrowseMentorsActivity;
import blueprint.com.sage.browse.BrowseSchoolsActivity;
import blueprint.com.sage.requests.CheckInRequestsActivity;
import blueprint.com.sage.requests.SignUpRequestsActivity;
import blueprint.com.sage.utility.view.FragUtils;
import butterknife.Bind;
import butterknife.ButterKnife;
import butterknife.OnClick;

/**
 * Created by charlesx on 12/24/15.
 */
public class AdminPanelFragment extends Fragment {

    @Bind(R.id.admin_browse_schools) LinearLayout mBrowseSchools;
    @Bind(R.id.admin_browse_users) LinearLayout mBrowseUsers;
    @Bind(R.id.admin_request_check_ins) LinearLayout mRequestCheckIns;
    @Bind(R.id.admin_request_users) LinearLayout mRequestUsers;
    @Bind(R.id.admin_settings_semester) LinearLayout mSettingsSemester;

    public static AdminPanelFragment newInstance() { return new AdminPanelFragment(); }

    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
    }

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup parent, Bundle savedInstanceState) {
        super.onCreateView(inflater, parent, savedInstanceState);
        View view = inflater.inflate(R.layout.fragment_admin_panel, parent, false);
        ButterKnife.bind(this, view);
        initializeViews();
        return view;
    }

    private void initializeViews() {

    }

    @OnClick(R.id.admin_browse_schools)
    public void onBrowseSchools(View view) {
        FragUtils.startActivityBackStack(getActivity(), BrowseSchoolsActivity.class);
    }

    @OnClick(R.id.admin_browse_users)
    public void onBrowseMentors(View view) {
        FragUtils.startActivityBackStack(getActivity(), BrowseMentorsActivity.class);
    }

    @OnClick(R.id.admin_request_check_ins)
    public void onRequestCheckIns(View view) {
        FragUtils.startActivityBackStack(getActivity(), CheckInRequestsActivity.class);
    }

    @OnClick(R.id.admin_request_users)
    public void onRequestUsers(View view) {
        FragUtils.startActivityBackStack(getActivity(), SignUpRequestsActivity.class);
    }

    @OnClick(R.id.admin_settings_semester)
    public void onSettingsSemester(View view) {
        // TODO: implement after millman gets his designs in
    }
}
