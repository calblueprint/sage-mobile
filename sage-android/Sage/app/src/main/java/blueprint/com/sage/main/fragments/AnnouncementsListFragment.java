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
import android.widget.ProgressBar;

import com.fasterxml.jackson.core.type.TypeReference;

import java.util.ArrayList;
import java.util.HashMap;

import blueprint.com.sage.R;
import blueprint.com.sage.announcements.AnnouncementActivity;
import blueprint.com.sage.announcements.CreateAnnouncementActivity;
import blueprint.com.sage.announcements.adapters.AnnouncementsListAdapter;
import blueprint.com.sage.events.announcements.AnnouncementsListEvent;
import blueprint.com.sage.models.Announcement;
import blueprint.com.sage.models.User;
import blueprint.com.sage.network.Requests;
import blueprint.com.sage.shared.interfaces.BaseInterface;
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

    private ArrayList<Announcement> mAnnouncements;
    private AnnouncementsListAdapter mAdapter;
    private BaseInterface mBaseInterface;

    @Bind(R.id.announcements_recycler) RecycleViewEmpty mAnnouncementsList;
    @Bind(R.id.announcements_list_empty_view) SwipeRefreshLayout mEmptyView;
    @Bind(R.id.announcements_list_refresh) SwipeRefreshLayout mAnnouncementsRefreshView;
    @Bind(R.id.list_progress_bar) ProgressBar mProgressBar;
    @Bind(R.id.add_announcement_fab) FloatingActionButton mAddAnnouncementButton;

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
        View view = inflater.inflate(R.layout.fragment_announcements_list, container, false);
        ButterKnife.bind(this, view);
        if (!mBaseInterface.getUser().isAdmin()) {
            mAddAnnouncementButton.setVisibility(View.GONE);
        }
        initializeViews();
        makeRequest();
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
        makeRequest();
    }

    public void onEvent(AnnouncementsListEvent event) {
        mAnnouncements = event.getMAnnouncements();
        mAdapter.setAnnouncements(mAnnouncements);
        mEmptyView.setRefreshing(false);
        mAnnouncementsRefreshView.setRefreshing(false);
    }

    public void initializeViews() {
        mAnnouncementsList.setLayoutManager(new LinearLayoutManager(getActivity()));
        mAnnouncementsList.setEmptyView(mEmptyView);
        mAnnouncementsList.setProgressBar(mProgressBar);

        mAdapter = new AnnouncementsListAdapter(mAnnouncements, getActivity(), getParentFragment());
        mAnnouncementsList.setAdapter(mAdapter);

        mAdapter.notifyDataSetChanged();
        mEmptyView.setOnRefreshListener(this);
        mAnnouncementsRefreshView.setOnRefreshListener(this);
    }

    public void makeRequest() {
        HashMap<String, String> map = new HashMap<>();
        map.put("sort[attr]", "created_at");
        map.put("sort[order]", "desc");
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
}
