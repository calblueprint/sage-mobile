package blueprint.com.sage.main.fragments;

import android.content.Context;
import android.content.Intent;
import android.content.SharedPreferences;
import android.os.Bundle;
import android.support.v4.app.Fragment;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.TextView;

import com.fasterxml.jackson.core.type.TypeReference;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

import blueprint.com.sage.R;
import blueprint.com.sage.admin.browse.BrowseSchoolsActivity;
import blueprint.com.sage.admin.browse.BrowseUsersActivity;
import blueprint.com.sage.admin.requests.VerifyCheckInRequestsActivity;
import blueprint.com.sage.admin.requests.VerifyUserRequestsActivity;
import blueprint.com.sage.admin.semester.CreateSemesterActivity;
import blueprint.com.sage.admin.semester.FinishSemesterActivity;
import blueprint.com.sage.admin.semester.PauseSemesterActivity;
import blueprint.com.sage.admin.semester.SemesterListActivity;
import blueprint.com.sage.events.semesters.SemesterListEvent;
import blueprint.com.sage.models.Semester;
import blueprint.com.sage.network.Requests;
import blueprint.com.sage.shared.interfaces.BaseInterface;
import blueprint.com.sage.utility.network.NetworkUtils;
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
    @Bind(R.id.admin_settings_pause_semester) View mPauseSemester;
    @Bind(R.id.admin_request_check_in_count) TextView mCheckInRequests;
    @Bind(R.id.admin_request_sign_up_count) TextView mSignUpRequests;

    private List<Semester> mSemesters;
    private BaseInterface mBaseInterface;

    public static AdminPanelFragment newInstance() { return new AdminPanelFragment(); }

    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

        mBaseInterface = (BaseInterface) getActivity();

        HashMap<String, String> queryParams = new HashMap<>();
        queryParams.put("current_semester", "true");
        Requests.Semesters.with(getActivity()).makeListRequest(queryParams);
    }

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup parent, Bundle savedInstanceState) {
        super.onCreateView(inflater, parent, savedInstanceState);
        View view = inflater.inflate(R.layout.fragment_admin_panel, parent, false);
        ButterKnife.bind(this, view);
        initializeBadges();
        return view;
    }

    @Override
    public void onStart() {
        super.onStart();
        EventBus.getDefault().register(this);
    }

    @Override
    public void onResume() {
        super.onResume();
        initializeBadges();
        toggleSemester();
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
        FragUtils.startActivityBackStack(getActivity(), BrowseUsersActivity.class);
    }

    @OnClick(R.id.admin_request_check_ins)
    public void onRequestCheckIns(View view) {
        FragUtils.startActivityBackStack(getActivity(), VerifyCheckInRequestsActivity.class);
    }

    @OnClick(R.id.admin_request_users)
    public void onRequestUsers(View view) {
        FragUtils.startActivityBackStack(getActivity(), VerifyUserRequestsActivity.class);
    }

    @OnClick(R.id.admin_settings_start_semester)
    public void onStartSemester(View view) {
        FragUtils.startActivityForResultFragment(getActivity(), getParentFragment(),
                CreateSemesterActivity.class,
                FragUtils.START_SEMESTER_REQUEST_CODE);
    }

    @OnClick(R.id.admin_settings_end_semester)
    public void onEndSemester(View view) {
        FragUtils.startActivityForResultFragment(getActivity(), getParentFragment(),
                FinishSemesterActivity.class,
                FragUtils.FINISH_SEMESTER_REQUEST_CODE);
    }

    @OnClick(R.id.admin_settings_browse_semesters)
    public void onBrowseSemesters(View view) {
        FragUtils.startActivityBackStack(getActivity(), SemesterListActivity.class);
    }

    @OnClick(R.id.admin_settings_pause_semester)
    public void onPauseSemester(View view) {
        FragUtils.startActivityForResultFragment(getActivity(), getParentFragment(),
                PauseSemesterActivity.class,
                FragUtils.PAUSE_SEMESTER_REQUEST_CODE);
    }

    private void initializeBadges() {
        SharedPreferences sharedPreferences = getActivity().getSharedPreferences(getActivity().getString(R.string.preferences),
                Context.MODE_PRIVATE);
        int checkInCount = Integer.valueOf(sharedPreferences.getString(getActivity().getString(R.string.admin_check_in_requests),
                getActivity().getString(R.string.admin_default_zero)));
        int signUpCount = Integer.valueOf(sharedPreferences.getString(getActivity().getString(R.string.admin_sign_up_requests),
                getActivity().getString(R.string.admin_default_zero)));

        if (checkInCount == 0) {
            mCheckInRequests.setVisibility(View.GONE);
        } else if (checkInCount >= 10 ) {
            mCheckInRequests.setText(R.string.admin_requests_plus);
        } else {
            mCheckInRequests.setText(String.valueOf(checkInCount));
        }

        if (signUpCount == 0) {
            mSignUpRequests.setVisibility(View.GONE);
        } else if (signUpCount >= 10 ) {
            mSignUpRequests.setText(R.string.admin_requests_plus);
        } else {
            mSignUpRequests.setText(String.valueOf(signUpCount));
        }
    }

    private void toggleSemester() {
        mStartSemester.setVisibility(View.GONE);
        mEndSemester.setVisibility(View.GONE);
        mPauseSemester.setVisibility(View.GONE);

        if (!mBaseInterface.getUser().isPresident()) {
            return;
        }

        if (mBaseInterface.getSharedPreferences().contains(getString(R.string.activity_current_semester))) {
            String semesterString =
                    mBaseInterface.getSharedPreferences().getString(getString(R.string.activity_current_semester), "");
            setSemester(semesterString);
            mEndSemester.setVisibility(View.VISIBLE);
            if (!mBaseInterface.getCurrentSemester().isPaused() && mBaseInterface.getCurrentSemester().getDatePaused() == null) {
                mPauseSemester.setVisibility(View.VISIBLE);
            }
        } else if (mSemesters == null || mSemesters.size() == 0) {
            mStartSemester.setVisibility(View.VISIBLE);
        } else if (mSemesters.size() == 1) {
            mEndSemester.setVisibility(View.VISIBLE);
            if (!mBaseInterface.getCurrentSemester().isPaused() && mBaseInterface.getCurrentSemester().getDatePaused() == null) {
                mPauseSemester.setVisibility(View.VISIBLE);
            }
        }
    }

    public void setSemester(String semesterString) {
        Semester semester = NetworkUtils.writeAsObject(getActivity(), semesterString, new TypeReference<Semester>() {});
        if (semester == null) return;
        mSemesters = new ArrayList<>();
        mSemesters.add(semester);

        mBaseInterface.setCurrentSemester(semester);
    }

    public void onStartSemester(Intent data) {
        String semesterString = data.getExtras().getString(getString(R.string.activity_create_semester), "");
        if (semesterString.isEmpty()) return;

        setSemester(semesterString);

        mBaseInterface.getSharedPreferences()
                .edit()
                .putString(getString(R.string.activity_current_semester), semesterString)
                .commit();
        toggleSemester();
    }

    public void onFinishSemester(Intent data) {
        mBaseInterface.getSharedPreferences()
                .edit()
                .remove(getString(R.string.activity_current_semester))
                .commit();
        mSemesters = new ArrayList<>();
        toggleSemester();
    }

    public void onPauseSemester(Intent data) {
        String semesterString = data.getExtras().getString(getString(R.string.activity_pause_semester), "");
        if (semesterString.isEmpty()) return;

        setSemester(semesterString);
        mBaseInterface.getSharedPreferences()
                .edit()
                .putString(getString(R.string.activity_current_semester), semesterString)
                .commit();
        toggleSemester();
    }

    public void onEvent(SemesterListEvent event) {
        mSemesters = event.getSemesters();
        toggleSemester();
    }
}
