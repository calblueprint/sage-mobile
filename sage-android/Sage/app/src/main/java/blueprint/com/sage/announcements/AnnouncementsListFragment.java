package blueprint.com.sage.announcements;

import android.os.Bundle;
import android.support.v4.app.Fragment;
import android.support.v7.widget.LinearLayoutManager;
import android.support.v7.widget.RecyclerView;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;

import java.util.ArrayList;

import blueprint.com.sage.R;
import blueprint.com.sage.announcements.adapters.AnnouncementsListAdapter;
import blueprint.com.sage.models.Announcement;
import butterknife.Bind;
import butterknife.ButterKnife;

/**
 * Created by kelseylam on 10/24/15.
 */
public class AnnouncementsListFragment extends Fragment {

    @Bind(R.id.announcements_recycler) RecyclerView announcementsList;

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

    public void initializeViews() {
        ArrayList<Announcement> announcements = new ArrayList<>();
        Announcement filler = new Announcement();
        filler.setBody("Wow, what a great announcement!");
        filler.setTitle("I love dogs");
        announcements.add(filler);
        announcements.add(filler);
        announcements.add(filler);
        announcements.add(filler);
        announcements.add(filler);
        announcements.add(filler);
        LinearLayoutManager llm = new LinearLayoutManager(getActivity());
        llm.setOrientation(LinearLayoutManager.VERTICAL);
        announcementsList.setLayoutManager(llm);
        AnnouncementsListAdapter adapter = new AnnouncementsListAdapter(announcements);
        announcementsList.setAdapter(adapter);
        adapter.notifyDataSetChanged();
        //set adapter, adapter.notifydatasetchanged, pass in arraylist to adapter
    }


}
