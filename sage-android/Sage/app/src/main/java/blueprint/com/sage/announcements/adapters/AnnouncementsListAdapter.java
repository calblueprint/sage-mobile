package blueprint.com.sage.announcements.adapters;

import android.content.Intent;
import android.support.v4.app.FragmentActivity;
import android.support.v7.widget.RecyclerView;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.TextView;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;

import java.util.ArrayList;

import blueprint.com.sage.R;
import blueprint.com.sage.announcements.AnnouncementActivity;
import blueprint.com.sage.models.Announcement;
import blueprint.com.sage.models.User;
import blueprint.com.sage.shared.views.CircleImageView;
import butterknife.Bind;
import butterknife.ButterKnife;
import butterknife.OnClick;

/**
 * Created by kelseylam on 10/24/15.
 */
public class AnnouncementsListAdapter extends RecyclerView.Adapter<AnnouncementsListAdapter.AnnouncementsListViewHolder> {

    private static ArrayList<Announcement> announcementArrayList;
    private FragmentActivity activity;

    public AnnouncementsListAdapter(ArrayList<Announcement> announcementArrayList, FragmentActivity activity) {
        this.announcementArrayList = announcementArrayList;
        this.activity = activity;
    }

    @Override
    public int getItemCount() {
        return announcementArrayList.size();
    }

    @Override
    public void onBindViewHolder(AnnouncementsListViewHolder viewHolder, int i) {
        Announcement announcement = announcementArrayList.get(i);
        User user = announcement.getUser();
        if (user != null) {
            viewHolder.vUser.setText(user.getName());
        }
        viewHolder.vTime.setText(announcement.getTime());
        viewHolder.vTitle.setText(announcement.getTitle());
        viewHolder.vBody.setText(announcement.getBody());
        user.loadUserImage(activity, viewHolder.vPicture);
    }

    public void setAnnouncements(ArrayList<Announcement> curList) {
        announcementArrayList = curList;
        notifyDataSetChanged();
    }

    @Override
    public AnnouncementsListViewHolder onCreateViewHolder(ViewGroup viewGroup, int i) {
        View view = LayoutInflater.from(viewGroup.getContext()).inflate(R.layout.announcement_row, viewGroup, false);
        return new AnnouncementsListViewHolder(view, activity);
    }


    public static class AnnouncementsListViewHolder extends RecyclerView.ViewHolder implements View.OnClickListener {

        FragmentActivity activity;

        @Bind(R.id.announcement_user) TextView vUser;
        @Bind(R.id.announcement_time) TextView vTime;
        @Bind(R.id.announcement_title) TextView vTitle;
        @Bind(R.id.announcement_body) TextView vBody;
        @Bind(R.id.announcement_profile_picture) CircleImageView vPicture;

        public AnnouncementsListViewHolder(View v, FragmentActivity activity) {
            super(v);
            this.activity = activity;
            ButterKnife.bind(this, v);
        }

        @OnClick(R.id.announcement_row)
        public void onClick(View v) {
            Announcement announcement = announcementArrayList.get(getAdapterPosition());
            Intent intent = new Intent(activity, AnnouncementActivity.class);
            intent.putExtra("Announcement", announcementToString(announcement));
            activity.startActivity(intent);
        }

        public String announcementToString(Announcement announcement) {
            ObjectMapper mapper = new ObjectMapper();
            String string = null;
            try {
                string = mapper.writeValueAsString(announcement);
            } catch (JsonProcessingException exception) {
            }
            return string;
        }
    }
}
