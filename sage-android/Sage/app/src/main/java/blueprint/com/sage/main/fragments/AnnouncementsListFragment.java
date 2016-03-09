package blueprint.com.sage.main.fragments;

import android.content.Intent;
import android.os.Bundle;
import android.support.design.widget.FloatingActionButton;
import android.support.v4.app.Fragment;
import android.support.v4.widget.SwipeRefreshLayout;
import android.support.v7.widget.LinearLayoutManager;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.LinearLayout;
import android.widget.ProgressBar;
import android.widget.RadioButton;
import android.widget.Spinner;

import com.fasterxml.jackson.core.type.TypeReference;

import java.util.ArrayList;
import java.util.HashMap;

import blueprint.com.sage.R;
import blueprint.com.sage.announcements.AnnouncementActivity;
import blueprint.com.sage.announcements.CreateAnnouncementActivity;
import blueprint.com.sage.announcements.adapters.AnnouncementsListAdapter;
import blueprint.com.sage.events.announcements.AnnouncementsListEvent;
import blueprint.com.sage.main.filters.AnnouncementsAllFilter;
import blueprint.com.sage.main.filters.AnnouncementsGeneralFilter;
import blueprint.com.sage.main.filters.AnnouncementsSchoolFilter;
import blueprint.com.sage.models.Announcement;
import blueprint.com.sage.models.User;
import blueprint.com.sage.network.Requests;
import blueprint.com.sage.shared.PaginationInstance;
import blueprint.com.sage.shared.adapters.spinners.SchoolSpinnerAdapter;
import blueprint.com.sage.shared.filters.FilterController;
import blueprint.com.sage.shared.interfaces.BaseInterface;
import blueprint.com.sage.shared.listeners.EndlessRecyclerViewScrollListener;
import blueprint.com.sage.shared.views.RecycleViewEmpty;
import blueprint.com.sage.utility.network.NetworkUtils;
import blueprint.com.sage.utility.view.FragUtils;
import butterknife.Bind;
import butterknife.ButterKnife;
import butterknife.OnClick;
import de.greenrobot.event.EventBus;

/**
 * Created by kelseylam on 10/24/15.
 */
public class AnnouncementsListFragment extends Fragment implements SwipeRefreshLayout.OnRefreshListener {

    private LinearLayoutManager mLinearLayoutManager;
    private PaginationInstance mPaginationInstance;
    private ArrayList<Announcement> mAnnouncements;
    private AnnouncementsListAdapter mAdapter;
    private BaseInterface mBaseInterface;

    @Bind(R.id.announcement_list_container) ViewGroup mContainer;
    @Bind(R.id.announcements_recycler) RecycleViewEmpty mAnnouncementsList;
    @Bind(R.id.announcements_list_empty_view) SwipeRefreshLayout mEmptyView;
    @Bind(R.id.announcements_list_refresh) SwipeRefreshLayout mAnnouncementsRefreshView;
    @Bind(R.id.list_progress_bar) ProgressBar mProgressBar;
    @Bind(R.id.add_announcement_fab) FloatingActionButton mAddAnnouncementButton;
    @Bind(R.id.filter_view) LinearLayout mFilterButton;

    // Filter related ui
    @Bind(R.id.announcement_filter_all) RadioButton mFilterAll;
    @Bind(R.id.announcement_filter_general) RadioButton mFilterGeneral;
    @Bind(R.id.announcement_filter_school) RadioButton mFilterSchool;
    @Bind(R.id.announcement_filter_school_spinner) Spinner mFilterSchoolSpinner;

    private SchoolSpinnerAdapter mSchoolAdapter;
    private FilterController mFilterController;
    private View mFilterView;

    public static AnnouncementsListFragment newInstance() { return new AnnouncementsListFragment(); }

    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        mAnnouncements = new ArrayList<>();
        mBaseInterface = (BaseInterface) getActivity();
    }

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
        super.onCreateView(inflater, container, savedInstanceState);
        ViewGroup view = (ViewGroup) inflater.inflate(R.layout.fragment_announcements_list, container, false);


        mFilterView = inflater.inflate(R.layout.fragment_announcements_filter, view, false);
        view.addView(mFilterView);
        ButterKnife.bind(this, view);

        initializeViews();
        initializeFilters();
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
    public void onRefresh() {
        mPaginationInstance.resetPage();
        makeAnnouncementsRequest();
    }

    public void onEvent(AnnouncementsListEvent event) {
        mAnnouncements = event.getAnnouncements();

        if (mPaginationInstance.hasResetPage()) {
            mAdapter.resetAnnouncements(mAnnouncements);
        } else {
            mAdapter.setAnnouncements(mAnnouncements);
        }

        mEmptyView.setRefreshing(false);
        mAnnouncementsRefreshView.setRefreshing(false);
        mPaginationInstance.incrementCurrentPage();
    }

    public void initializeViews() {
        if (!mBaseInterface.getUser().isAdmin()) {
            mAddAnnouncementButton.setVisibility(View.GONE);
        }

        mPaginationInstance = PaginationInstance.newInstance();
        mLinearLayoutManager = new LinearLayoutManager(getActivity());
        mAnnouncementsList.setLayoutManager(mLinearLayoutManager);
        mAnnouncementsList.setEmptyView(mEmptyView);
        mAnnouncementsList.setProgressBar(mProgressBar);
        mAnnouncementsList.addOnScrollListener(
                new EndlessRecyclerViewScrollListener(mLinearLayoutManager, mPaginationInstance) {
                    @Override
                    public void onLoadMore() {
                        makeAnnouncementsRequest();
                    }
                });

        mAdapter = new AnnouncementsListAdapter(mAnnouncements, getActivity(), getParentFragment());
        mAnnouncementsList.setAdapter(mAdapter);

        mEmptyView.setOnRefreshListener(this);
        mAnnouncementsRefreshView.setOnRefreshListener(this);

        makeAnnouncementsRequest();
    }

    private void initializeFilters() {
        mFilterView.setVisibility(View.GONE);

        AnnouncementsAllFilter allFilter = new AnnouncementsAllFilter(mFilterAll);
        AnnouncementsGeneralFilter generalFilter = new AnnouncementsGeneralFilter(mFilterGeneral);
        AnnouncementsSchoolFilter schoolFilter = new AnnouncementsSchoolFilter(mFilterSchool, mFilterSchoolSpinner);

        mFilterController = new FilterController();
        mFilterController.addFilters(allFilter, generalFilter, schoolFilter);

    }

    public void makeAnnouncementsRequest() {
        HashMap<String, String> map = new HashMap<>();
        map.put("sort[attr]", "created_at");
        map.put("sort[order]", "desc");
        map.put("page", "" + mPaginationInstance.getCurrentPage());
        User user = mBaseInterface.getUser();
        if (user.isStudent() && user.getSchoolId() != 0) {
            int id = user.getSchoolId();
            map.put("default", Integer.toString(id));
        }
        Requests.Announcements.with(getActivity()).makeListRequest(map);
    }

    @OnClick(R.id.add_announcement_fab)
    public void newAnnouncement() {
        FragUtils.startActivityForResultFragment(getActivity(), getParentFragment(), CreateAnnouncementActivity.class, FragUtils.CREATE_ANNOUNCEMENT_REQUEST_CODE);
    }

    public void addAnnouncement(Intent data) {
        String string = data.getStringExtra(getString(R.string.create_announcement));
        Announcement announcement = NetworkUtils.writeAsObject(getActivity(), string, new TypeReference<Announcement>(){});
        mAnnouncements.add(0, announcement);
        mAdapter.setAnnouncements(mAnnouncements);
        mAdapter.notifyDataSetChanged();
    }

    public void changeAnnouncement(Intent data) {
        int type = data.getIntExtra(getString(R.string.announcement_type), AnnouncementActivity.ORIGINAL);
        String string = data.getStringExtra(getString(R.string.change_announcement));
        Announcement announcement = NetworkUtils.writeAsObject(getActivity(), string, new TypeReference<Announcement>() {});
        if (type == AnnouncementActivity.ORIGINAL) {
            return;
        }
        int index = 0;
        for (int i = 0; i < mAnnouncements.size(); i++) {
            if (mAnnouncements.get(i).getId() == announcement.getId()) {
                index = i;
            }
        }
        switch (type) {
            case AnnouncementActivity.DELETED:
                mAnnouncements.remove(index);
                break;
            case AnnouncementActivity.EDITED:
                mAnnouncements.set(index, announcement);
                break;
        }
        mAdapter.setAnnouncements(mAnnouncements);
        mAdapter.notifyDataSetChanged();
    }

    /**
     * Filtering section
     */

    @OnClick(R.id.filter_view)
    public void onFilterViewShow() {

    }

    public void onFilterViewHide() {

    }
}
