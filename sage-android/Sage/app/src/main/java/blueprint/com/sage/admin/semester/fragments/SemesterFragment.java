package blueprint.com.sage.admin.semester.fragments;

import android.os.Bundle;
import android.support.design.widget.TabLayout;
import android.support.v4.app.Fragment;
import android.support.v4.view.ViewPager;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.Menu;
import android.view.MenuInflater;
import android.view.MenuItem;
import android.view.View;
import android.view.ViewGroup;
import android.widget.Toast;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

import blueprint.com.sage.R;
import blueprint.com.sage.events.APIErrorEvent;
import blueprint.com.sage.events.checkIns.CheckInListEvent;
import blueprint.com.sage.events.semesters.ExportSemesterEvent;
import blueprint.com.sage.events.semesters.SemesterEvent;
import blueprint.com.sage.events.users.UserListEvent;
import blueprint.com.sage.models.APIError;
import blueprint.com.sage.models.CheckIn;
import blueprint.com.sage.models.Semester;
import blueprint.com.sage.models.User;
import blueprint.com.sage.network.Requests;
import blueprint.com.sage.shared.adapters.pagers.SimplePagerAdapter;
import blueprint.com.sage.shared.interfaces.CheckInsInterface;
import blueprint.com.sage.shared.interfaces.UsersInterface;
import blueprint.com.sage.utility.view.ViewUtils;
import butterknife.Bind;
import butterknife.ButterKnife;
import de.greenrobot.event.EventBus;

/**
 * Created by charlesx on 1/7/16.
 * Shows an individual semester
 */
public class SemesterFragment extends Fragment implements UsersInterface, CheckInsInterface {

    @Bind(R.id.tab_view) TabLayout mTabLayout;
    @Bind(R.id.view_pager) ViewPager mViewPager;

    private List<User> mUsers;
    private List<CheckIn> mCheckIns;
    private Semester mSemester;
    private SimplePagerAdapter mAdapter;

    private MenuItem mItem;

    public static SemesterFragment newInstance(Semester semester) {
        SemesterFragment fragment = new SemesterFragment();
        fragment.setSemester(semester);
        return fragment;
    }

    public void setSemester(Semester semester) { mSemester = semester; }

    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setHasOptionsMenu(true);
        mCheckIns = new ArrayList<>();
        mUsers = new ArrayList<>();

        Requests.Semesters.with(getActivity()).makeShowRequest(mSemester);
    }

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup parent, Bundle savedInstanceState) {
        super.onCreateView(inflater, parent, savedInstanceState);
        View view = inflater.inflate(R.layout.fragment_semester, parent, false);
        ButterKnife.bind(this, view);
        initializeViews();
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

    @Override
    public void onDestroyView() {
        super.onDestroy();
        ViewUtils.setToolBarElevation(getActivity(), 8);
    }

    @Override
    public void onCreateOptionsMenu(Menu menu, MenuInflater inflater) {
        menu.clear();
        int menuId = mSemester.getFinish() != null ? R.menu.menu_export : R.menu.menu_empty;
        inflater.inflate(menuId, menu);
        super.onCreateOptionsMenu(menu, inflater);
    }

    @Override
    public boolean onOptionsItemSelected(MenuItem item) {
        mItem = item;
        switch (item.getItemId()) {
            case R.id.menu_export:
                exportSemester();
            default:
                return super.onOptionsItemSelected(item);
        }
    }

    private void initializeViews() {
        mAdapter = new SimplePagerAdapter(getChildFragmentManager());

        mAdapter.addFragment(SemesterUserListFragment.newInstance(mSemester), "User");
        mAdapter.addFragment(SemesterCheckInListFragment.newInstance(), "Check In");

        mViewPager.setAdapter(mAdapter);
        mTabLayout.setupWithViewPager(mViewPager);

        ViewUtils.setToolBarElevation(getActivity(), 0);

        getActivity().setTitle(R.string.semester);
    }

    private void exportSemester() {
        mItem.setActionView(R.layout.actionbar_indeterminate_progress);
        Requests.Semesters.with(getActivity()).makeExportRequest(mSemester);
    }

    public void onEvent(SemesterEvent event) {
        mSemester = event.getSemester();

        EventBus.getDefault().post(new CheckInListEvent(mSemester.getCheckIns()));
        EventBus.getDefault().post(new UserListEvent(mSemester.getUsers()));
    }

    public void onEvent(ExportSemesterEvent event) {
        Log.e("made even", "made");
        Toast.makeText(getActivity(), event.getApiSuccess().getMessage(), Toast.LENGTH_SHORT).show();
        mItem.setActionView(null);
    }

    public void onEvent(APIError event) { mItem.setActionView(null); }

    public void setUsers(List<User> users) { mUsers = users; }
    public List<User> getUsers() { return mUsers; }

    public void getUsersListRequest() {
        if (mSemester == null) {
            EventBus.getDefault().post(new APIErrorEvent(new APIError()));
        }

        HashMap<String, String> queryParams = new HashMap<>();
        queryParams.put("semester_id", String.valueOf(mSemester.getId()));
        Requests.Users.with(getActivity()).makeListRequest(queryParams);
    }

    public void setCheckIns(List<CheckIn> checkIns) { mCheckIns = checkIns; }
    public List<CheckIn> getCheckIns() { return mCheckIns; }

    public void getCheckInListRequest() {
        if (mSemester == null) {
            EventBus.getDefault().post(new APIErrorEvent(new APIError()));
        }

        HashMap<String, String> queryParams = new HashMap<>();
        queryParams.put("semester_id", String.valueOf(mSemester.getId()));
        Requests.CheckIns.with(getActivity()).makeListRequest(queryParams);
    }

}
