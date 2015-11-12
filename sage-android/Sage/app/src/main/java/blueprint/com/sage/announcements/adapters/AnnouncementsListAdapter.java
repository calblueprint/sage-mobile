package blueprint.com.sage.announcements.adapters;

import android.support.v4.app.FragmentActivity;
import android.support.v7.widget.RecyclerView;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.TextView;
import android.widget.Toast;

import com.android.volley.Response;

import org.joda.time.DateTime;
import org.joda.time.Period;

import java.util.ArrayList;

import blueprint.com.sage.R;
import blueprint.com.sage.announcements.AnnouncementFragment;
import blueprint.com.sage.models.APIError;
import blueprint.com.sage.models.Announcement;
import blueprint.com.sage.network.announcements.AnnouncementRequest;
import blueprint.com.sage.shared.views.CircleImageView;
import blueprint.com.sage.utility.network.NetworkManager;
import blueprint.com.sage.utility.view.FragUtil;
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
        viewHolder.vUser.setText(announcement.getUserName());
        viewHolder.vTime.setText(getTime(announcement));
        viewHolder.vTitle.setText(announcement.getTitle());
        viewHolder.vBody.setText(announcement.getBody());
//        Picasso picasso = Picasso.with(activity);
//        picasso.load(announcement.getUser().getImageUrl()).into(viewHolder.vPicture);
    }

    public String getTime(Announcement announcement) {
        DateTime dateTime = new DateTime(announcement.getCreatedAt());
        Period period = new Period(dateTime, DateTime.now());
        long seconds = period.getSeconds  ();
        long minutes = period.getMinutes();
        long hours = period.getHours();
        long days = period.getDays();
//        long weeks = period.getWeeks();
        long months = period.getMonths();
        long years = period.getYears();
        String date;
        if (seconds < 0) {
            date = "not yet";
        }
        else if (seconds < 60) {
            date = seconds == 1 ? "one second ago" : seconds + " seconds ago";
        }
        else if (seconds < 120) {
            date = "a minute ago";
        }
        else if (seconds < 2700) { // 45 * 60
            date = minutes + " minutes ago";
        }
        else if (seconds < 5400) { // 90 * 60
            date = "an hour ago";
        }
        else if (seconds < 86400) { // 24 * 60 * 60
            date = hours + " hours ago";
        }
        else if (seconds < 172800) { // 48 * 60 * 60
            date = "yesterday";
        }
        else if (seconds < 2592000) { // 30 * 24 * 60 * 60
            date = days + " days ago";
        }
        else if (seconds < 31104000) { // 12 * 30 * 24 * 60 * 60
            date = months <= 1 ? "one month ago" : days + " months ago";
        }
        else {
            date = years <= 1 ? "one year ago" : years + " years ago";
        }
        return date;
    }

    public void setAnnouncement(ArrayList<Announcement> curList) {
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
//
        @OnClick(R.id.announcement_row)
        public void onClick(View v){
            NetworkManager networkManager = NetworkManager.getInstance(activity);
            Announcement announcement = announcementArrayList.get(getAdapterPosition());
            Toast.makeText(activity, "id:" + getAdapterPosition(), Toast.LENGTH_SHORT);
            AnnouncementRequest announcementRequest = new AnnouncementRequest(activity, announcement.getId(), new Response.Listener<Announcement>() {
                @Override
                public void onResponse(Announcement announcement) {
                    FragUtil.replace(R.id.announcements_container, AnnouncementFragment.newInstance(), activity);
                }
            }, new Response.Listener<APIError>() {
                @Override
                public void onResponse(APIError apiError) {

                }
            });
            networkManager.getRequestQueue().add(announcementRequest);
        }
    }

}
