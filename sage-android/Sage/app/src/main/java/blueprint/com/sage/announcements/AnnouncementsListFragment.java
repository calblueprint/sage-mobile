package blueprint.com.sage.announcements;

import android.os.Bundle;
import android.support.design.widget.FloatingActionButton;
import android.support.v4.app.Fragment;
import android.support.v4.widget.SwipeRefreshLayout;
import android.support.v7.widget.LinearLayoutManager;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;

import java.util.ArrayList;

import blueprint.com.sage.R;
import blueprint.com.sage.announcements.adapters.AnnouncementsListAdapter;
import blueprint.com.sage.events.announcements.AnnouncementsListEvent;
import blueprint.com.sage.models.Announcement;
import blueprint.com.sage.network.Requests;
import blueprint.com.sage.shared.views.RecycleViewEmpty;
import blueprint.com.sage.utility.view.FragUtils;
import butterknife.Bind;
import butterknife.ButterKnife;
import butterknife.OnClick;
import de.greenrobot.event.EventBus;

/**
 * Created by kelseylam on 10/24/15.
 */
public class AnnouncementsListFragment extends Fragment implements SwipeRefreshLayout.OnRefreshListener {

    private ArrayList<Announcement> announcementsArrayList = new ArrayList<>();
    private AnnouncementsListAdapter adapter;

    @Bind(R.id.announcements_recycler) RecycleViewEmpty announcementsList;
    @Bind(R.id.announcements_list_empty_view) SwipeRefreshLayout mEmptyView;
    @Bind(R.id.announcements_list_refresh) SwipeRefreshLayout mAnnouncementsRefreshView;
    @Bind(R.id.add_announcement_fab) FloatingActionButton addAnnouncementButton;

    public static AnnouncementsListFragment newInstance() {
        return new AnnouncementsListFragment();
    }

    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
    }

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
        super.onCreateView(inflater, container, savedInstanceState);
        View view = inflater.inflate(R.layout.fragment_announcements_list, container, false);
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
        EventBus.getDefault().unregister(this);
        super.onStop();
    }

    public void onEvent(AnnouncementsListEvent event) {
        announcementsArrayList = event.getAnnouncements();
        adapter.setAnnouncements(announcementsArrayList);
        mEmptyView.setRefreshing(false);
        mAnnouncementsRefreshView.setRefreshing(false);
    }

    public void initializeViews() {
        LinearLayoutManager llm = new LinearLayoutManager(getActivity());
        llm.setOrientation(LinearLayoutManager.VERTICAL);
        announcementsList.setLayoutManager(llm);
        announcementsList.setEmptyView(mEmptyView);
        adapter = new AnnouncementsListAdapter(announcementsArrayList, getActivity());
        announcementsList.setAdapter(adapter);
        adapter.notifyDataSetChanged();
        mEmptyView.setOnRefreshListener(this);
        mAnnouncementsRefreshView.setOnRefreshListener(this);
    }

    @Override
    public void onRefresh() {
        Requests.Announcements.with(getActivity()).makeListRequest();
    }

    @OnClick(R.id.add_announcement_fab)
    public void newAnnouncement() {
        FragUtils.replaceBackStack(R.id.container, CreateAnnouncementFragment.newInstance(), getActivity());
    }
}
