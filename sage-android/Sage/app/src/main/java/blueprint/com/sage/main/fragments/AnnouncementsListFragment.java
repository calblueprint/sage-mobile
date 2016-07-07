package blueprint.com.sage.main.fragments;

import android.content.Intent;
import android.os.Bundle;
import android.support.design.widget.FloatingActionButton;
import android.support.v4.widget.SwipeRefreshLayout;
import android.support.v7.widget.LinearLayoutManager;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ProgressBar;
import android.widget.RadioButton;
import android.widget.Spinner;

import com.fasterxml.jackson.core.type.TypeReference;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

import blueprint.com.sage.R;
import blueprint.com.sage.announcements.AnnouncementActivity;
import blueprint.com.sage.announcements.CreateAnnouncementActivity;
import blueprint.com.sage.announcements.adapters.AnnouncementsListAdapter;
import blueprint.com.sage.events.announcements.AnnouncementNotificationEvent;
import blueprint.com.sage.events.announcements.AnnouncementsListEvent;
import blueprint.com.sage.events.schools.SchoolListEvent;
import blueprint.com.sage.main.filters.AnnouncementsAllFilter;
import blueprint.com.sage.main.filters.AnnouncementsGeneralFilter;
import blueprint.com.sage.main.filters.AnnouncementsMySchoolFilter;
import blueprint.com.sage.main.filters.AnnouncementsSchoolFilter;
import blueprint.com.sage.models.Announcement;
import blueprint.com.sage.models.School;
import blueprint.com.sage.network.Requests;
import blueprint.com.sage.shared.PaginationInstance;
import blueprint.com.sage.shared.adapters.spinners.SchoolSpinnerAdapter;
import blueprint.com.sage.shared.fragments.ListFilterFragment;
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
public class AnnouncementsListFragment extends ListFilterFragment implements SwipeRefreshLayout.OnRefreshListener {

    private LinearLayoutManager mLinearLayoutManager;
    private PaginationInstance mPaginationInstance;
    private ArrayList<Announcement> mAnnouncements;
    private AnnouncementsListAdapter mAnnouncementsAdapter;
    private BaseInterface mBaseInterface;

    @Bind(R.id.announcement_list_container) ViewGroup mContainer;
    @Bind(R.id.announcements_recycler) RecycleViewEmpty mAnnouncementsList;
    @Bind(R.id.announcements_list_empty_view) SwipeRefreshLayout mEmptyView;
    @Bind(R.id.announcements_list_refresh) SwipeRefreshLayout mAnnouncementsRefreshView;
    @Bind(R.id.list_progress_bar) ProgressBar mProgressBar;
    @Bind(R.id.add_announcement_fab) FloatingActionButton mAddAnnouncementButton;

    @Bind(R.id.announcement_filter_all_layout) View mFilterAllLayout;
    @Bind(R.id.announcement_filter_my_school_layout) View mFilterMySchoolLayout;
    @Bind(R.id.announcement_filter_school_layout) View mFilterSchoolLayout;

    @Bind(R.id.announcement_filter_all) RadioButton mFilterAll;
    @Bind(R.id.announcement_filter_general) RadioButton mFilterGeneral;
    @Bind(R.id.announcement_filter_school) RadioButton mFilterSchool;
    @Bind(R.id.announcement_filter_my_school) RadioButton mFilterMySchool;
    @Bind(R.id.announcement_filter_school_spinner) Spinner mFilterSchoolSpinner;

    private SchoolSpinnerAdapter mSchoolAdapter;
    private List<School> mSchools;

    public static AnnouncementsListFragment newInstance() { return new AnnouncementsListFragment(); }

    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        mAnnouncements = new ArrayList<>();
        mSchools = new ArrayList<>();
        mBaseInterface = (BaseInterface) getActivity();
    }

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
        super.onCreateView(inflater, container, savedInstanceState);
        ViewGroup view = (ViewGroup) inflater.inflate(R.layout.fragment_announcements_list, container, false);
        ButterKnife.bind(this, view);

        initializeFilters();
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
    public void onRefresh() {
        mPaginationInstance.resetPage();
        makeAnnouncementsRequest();
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

        mAnnouncementsAdapter = new AnnouncementsListAdapter(mAnnouncements, getActivity(), getParentFragment());
        mAnnouncementsList.setAdapter(mAnnouncementsAdapter);

        mEmptyView.setOnRefreshListener(this);
        mAnnouncementsRefreshView.setOnRefreshListener(this);

        makeAnnouncementsRequest();
    }

    public void initializeFilters() {
        mFilterView.setVisibility(View.GONE);

        if (mBaseInterface.getSchool() != null) {
            AnnouncementsMySchoolFilter mySchoolFilter = new AnnouncementsMySchoolFilter(mFilterMySchool, mBaseInterface.getSchool());
            mFilterController.addFilters(mySchoolFilter);
            mFilterMySchoolLayout.setVisibility(View.VISIBLE);
        }

        if (mBaseInterface.getUser().isAdmin()) {
            AnnouncementsSchoolFilter schoolFilter = new AnnouncementsSchoolFilter(mFilterSchool, mFilterSchoolSpinner);
            mFilterController.addFilters(schoolFilter);
            mFilterSchoolLayout.setVisibility(View.VISIBLE);

            mSchoolAdapter = new SchoolSpinnerAdapter(getActivity(), mSchools, R.layout.filter_spinner_header, R.layout.filter_spinner_item);
            mFilterSchoolSpinner.setAdapter(mSchoolAdapter);
            makeSchoolsRequest();
        }

        AnnouncementsGeneralFilter generalFilter = new AnnouncementsGeneralFilter(mFilterGeneral);
        mFilterController.addFilters(generalFilter);

        if (mBaseInterface.getUser().isAdmin() || mBaseInterface.getSchool() != null) {
            AnnouncementsAllFilter allFilter = new AnnouncementsAllFilter(mFilterAll, mBaseInterface.getUser(), mBaseInterface.getSchool());
            mFilterController.addFilters(allFilter);
            mFilterAllLayout.setVisibility(View.VISIBLE);

            mFilterController.onFilterChecked(mFilterAll.getId());
        } else {
            mFilterController.onFilterChecked(mFilterGeneral.getId());
        }
    }

    public void makeAnnouncementsRequest() {
        HashMap<String, String> map = new HashMap<>();
        map.put("sort[attr]", "created_at");
        map.put("sort[order]", "desc");
        map.put("page", "" + mPaginationInstance.getCurrentPage());
        map.putAll(mFilterController.onFilter());

        Requests.Announcements.with(getActivity()).makeListRequest(map);
    }

    public void makeSchoolsRequest() {
        HashMap<String, String> queryParams = new HashMap<>();
        queryParams.put("sort[attr]", "lower(name)");
        queryParams.put("sort[order]", "asc");
        Requests.Schools.with(getActivity()).makeListRequest(queryParams);
    }

    @OnClick(R.id.add_announcement_fab)
    public void newAnnouncement() {
        FragUtils.startActivityForResultFragment(getActivity(), getParentFragment(), CreateAnnouncementActivity.class, FragUtils.CREATE_ANNOUNCEMENT_REQUEST_CODE);
    }

    public void addAnnouncement(Intent data) {
        String string = data.getStringExtra(getString(R.string.create_announcement));
        Announcement announcement = NetworkUtils.writeAsObject(getActivity(), string, new TypeReference<Announcement>() {});
        mAnnouncements.add(0, announcement);
        mAnnouncementsAdapter.setAnnouncements(mAnnouncements);
        mAnnouncementsAdapter.notifyDataSetChanged();
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
        mAnnouncementsAdapter.setAnnouncements(mAnnouncements);
        mAnnouncementsAdapter.notifyDataSetChanged();
    }

    public void onEvent(AnnouncementsListEvent event) {
        mAnnouncements = event.getAnnouncements();

        if (mPaginationInstance.hasResetPage()) {
            mAnnouncementsAdapter.resetAnnouncements(mAnnouncements);
        } else {
            mAnnouncementsAdapter.setAnnouncements(mAnnouncements);
        }

        mEmptyView.setRefreshing(false);
        mAnnouncementsRefreshView.setRefreshing(false);
        mPaginationInstance.incrementCurrentPage();
    }

    public void onEvent(SchoolListEvent event) {
        mSchools = event.getSchools();
        mSchoolAdapter.setSchools(mSchools);
    }

    public void onEvent(final AnnouncementNotificationEvent event) {
        if (shouldAddNotification(event.getAnnouncement())) {
            getActivity().runOnUiThread(new Runnable() {
                @Override
                public void run() {
                    mAnnouncementsAdapter.addAnnouncement(event.getAnnouncement());
                    mAnnouncementsList.smoothScrollToPosition(0);
                }
            });
        }
    }

    private boolean shouldAddNotification(Announcement announcement) {
        return mFilterAll.isChecked() ||
                (announcement.isGeneral() || mFilterGeneral.isChecked()) ||
                (announcement.getSchoolId() ==
                        mSchoolAdapter.getItem(mFilterSchoolSpinner.getSelectedItemPosition()).getId());
    }

    /**
     * Filtering section
     */
    @OnClick({ R.id.announcement_filter_my_school, R.id.announcement_filter_all, R.id.announcement_filter_general, R.id.announcement_filter_school })
    public void onRadioButtonClick(View view) {
        mFilterController.onFilterChecked(view.getId());
    }

    public void onFilterClick() {
        mPaginationInstance.resetPage();
        mEmptyView.setRefreshing(true);
        mAnnouncementsRefreshView.setRefreshing(true);
        makeAnnouncementsRequest();
        onFilterViewHide();
    }
}
