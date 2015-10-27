package blueprint.com.sage.announcements.adapters;

import android.support.v7.widget.RecyclerView;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.TextView;

import java.util.ArrayList;

import blueprint.com.sage.R;
import blueprint.com.sage.models.Announcement;
import butterknife.Bind;
import butterknife.ButterKnife;

/**
 * Created by kelseylam on 10/24/15.
 */
public class AnnouncementsListAdapter extends RecyclerView.Adapter<AnnouncementsListAdapter.AnnouncementsListViewHolder> {

    private ArrayList<Announcement> announcementArrayList;

    public AnnouncementsListAdapter(ArrayList<Announcement> announcementArrayList) {
        this.announcementArrayList = announcementArrayList;
    }

    @Override
    public int getItemCount() {
        return announcementArrayList.size();
    }

    @Override
    public void onBindViewHolder(AnnouncementsListViewHolder viewHolder, int i) {
        Announcement announcement = announcementArrayList.get(i);
//        viewHolder.vUser.setText(announcement.);
//        viewHolder.vTime.setText(announcement.);
        viewHolder.vTitle.setText(announcement.getTitle());
        viewHolder.vBody.setText(announcement.getBody());
    }

    @Override
    public AnnouncementsListViewHolder onCreateViewHolder(ViewGroup viewGroup, int i) {
        View view = LayoutInflater.from(viewGroup.getContext()).inflate(R.layout.announcement_row, viewGroup, false);
        return new AnnouncementsListViewHolder(view);
    }


    public static class AnnouncementsListViewHolder extends RecyclerView.ViewHolder {

        @Bind(R.id.announcement_user) TextView vUser;
        @Bind(R.id.announcement_time) TextView vTime;
        @Bind(R.id.announcement_title) TextView vTitle;
        @Bind(R.id.announcement_body) TextView vBody;

        public AnnouncementsListViewHolder(View v) {
            super(v);
            ButterKnife.bind(this, v);
        }
    }

}
