package blueprint.com.sage.main.fragments;

import android.os.Bundle;
import android.support.v4.app.Fragment;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;

import java.util.HashMap;
import java.util.List;

import blueprint.com.sage.R;
import blueprint.com.sage.browse.BrowseMentorsActivity;
import blueprint.com.sage.browse.BrowseSchoolsActivity;
import blueprint.com.sage.events.semesters.SemesterListEvent;
import blueprint.com.sage.models.Semester;
import blueprint.com.sage.network.Requests;
import blueprint.com.sage.requests.CheckInRequestsActivity;
import blueprint.com.sage.requests.SignUpRequestsActivity;
import blueprint.com.sage.semester.CreateSemesterActivity;
import blueprint.com.sage.utility.view.FragUtils;
import butterknife.Bind;
import butterknife.ButterKnife;
import butterknife.OnClick;
import de.greenrobot.event.EventBus;

/**
 * Created by charlesx on 12/24/15.
 */
public class AdminPanelFragment extends Fragment {

    @Bind(R.id.admin_settings_start_semester) View mStartSemester;
    @Bind(R.id.admin_settings_end_semester) View mEndSemester;

    private List<Semester> mSemesters;

    public static AdminPanelFragment newInstance() { return new AdminPanelFragment(); }

    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

        HashMap<String, String> queryParams = new HashMap<>();
        queryParams.put("current_semester", "true");
        Requests.Semesters.with(getActivity()).makeListRequest(queryParams);
    }

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup parent, Bundle savedInstanceState) {
        super.onCreateView(inflater, parent, savedInstanceState);
        View view = inflater.inflate(R.layout.fragment_admin_panel, parent, false);
        ButterKnife.bind(this, view);
        toggleSemester();
        return view;
    }

    @Override
    public void onStart() {
        super.onStart();
        EventBus.getDefault().register(this);
    }

    @Override
    public void onStop() {
        super.onStop();
        EventBus.getDefault().unregister(this);
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

    @OnClick(R.id.admin_settings_start_semester)
    public void onStartSemester(View view) {
        FragUtils.startActivityBackStack(getActivity(), CreateSemesterActivity.class);
    }

    @OnClick(R.id.admin_settings_end_semester)
    public void onEndSemester(View view) {
        // TODO: implement after millman gets his designs in
    }

    @OnClick(R.id.admin_settings_browse_semesters)
    public void onBrowseSemesters(View view) {
        // TODO: implement after millman gets his designs in
    }

    public void onEvent(SemesterListEvent event) {
        mSemesters = event.getSemesters();
        toggleSemester();
    }

    private void toggleSemester() {
        mStartSemester.setVisibility(View.GONE);
        mEndSemester.setVisibility(View.GONE);

        if (mSemesters == null)
            return;

        if (mSemesters.size() == 0) {
            mStartSemester.setVisibility(View.VISIBLE);
        } else if (mSemesters.size() == 1) {
            mStartSemester.setVisibility(View.VISIBLE);
        }
    }
}
