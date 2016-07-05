package blueprint.com.sage.announcements.adapters;

import android.content.Intent;
import android.support.v4.app.Fragment;
import android.support.v4.app.FragmentActivity;
import android.support.v7.widget.RecyclerView;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.TextView;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;

import java.util.ArrayList;
import java.util.List;

import blueprint.com.sage.R;
import blueprint.com.sage.announcements.AnnouncementActivity;
import blueprint.com.sage.models.Announcement;
import blueprint.com.sage.models.User;
import blueprint.com.sage.shared.views.CircleImageView;
import blueprint.com.sage.shared.views.ProgressViewHolder;
import blueprint.com.sage.utility.view.FragUtils;
import butterknife.Bind;
import butterknife.ButterKnife;
import butterknife.OnClick;
import lombok.Data;

/**
 * Created by kelseylam on 10/24/15.
 */
public class AnnouncementsListAdapter extends RecyclerView.Adapter<RecyclerView.ViewHolder> {

    private final int ANNOUNCEMENT_VIEW = 0;
    private final int LOADING_VIEW = 1;

    public List<Item> mItems;
    private FragmentActivity mActivity;
    private Fragment mFragment;

    public AnnouncementsListAdapter(ArrayList<Announcement> announcementArrayList, FragmentActivity activity, Fragment fragment) {
        mActivity = activity;
        mFragment = fragment;

        setUpAnnouncements(announcementArrayList, true);
    }

    private void setUpAnnouncements(List<Announcement> announcements, boolean hasReset) {
        if (mItems == null || hasReset) {
            mItems = new ArrayList<>();
        }

        if (mItems.size() > 0 && mItems.get(mItems.size() - 1).getType() == LOADING_VIEW) {
            mItems.remove(mItems.size() - 1);
        }

        for (Announcement announcement : announcements) {
            mItems.add(new Item(announcement, "", ANNOUNCEMENT_VIEW));
        }

        if (announcements.size() != 0) {
            mItems.add(new Item(null, "", LOADING_VIEW));
        }
    }

    @Override
    public int getItemCount() {
        return mItems.size();
    }

    @Override
    public RecyclerView.ViewHolder onCreateViewHolder(ViewGroup parent, int viewType) {
        LayoutInflater inflater = LayoutInflater.from(mActivity);
        View view;

        switch (viewType) {
            case ANNOUNCEMENT_VIEW:
                view = inflater.inflate(R.layout.announcement_row, parent, false);
                return new AnnouncementsListViewHolder(view, mActivity, mFragment);
            case LOADING_VIEW:
                view = inflater.inflate(R.layout.progress_list_item, parent, false);
                return new ProgressViewHolder(view);
        }

        return null;
    }


    @Override
    public void onBindViewHolder(RecyclerView.ViewHolder viewHolder, int position) {
        Item item = mItems.get(position);

        switch (item.getType()) {
            case ANNOUNCEMENT_VIEW:
                onBindAnnouncementViewHolder((AnnouncementsListViewHolder) viewHolder, item.getAnnouncement());
                break;
            case LOADING_VIEW:
                break;
        }
    }

    private void onBindAnnouncementViewHolder(AnnouncementsListViewHolder viewHolder, Announcement announcement) {
        User user = announcement.getUser();
        viewHolder.mUser.setText(user.getName());
        user.loadUserImage(mActivity, viewHolder.mPicture);

        viewHolder.mTime.setText(announcement.getTime());
        viewHolder.mTitle.setText(announcement.getTitle());
        viewHolder.mBody.setText(announcement.getBody());

        if (announcement.getSchool() != null) {
            viewHolder.mSchool.setVisibility(View.VISIBLE);
            viewHolder.mSchool.setText("to " + announcement.getSchool().getName());
        } else {
            viewHolder.mSchool.setVisibility(View.GONE);
        }
    }

    @Override
    public int getItemViewType(int position) {
        return mItems.get(position).getType();
    }

    public void resetAnnouncements(List<Announcement> announcementList) {
        setUpAnnouncements(announcementList, true);
        notifyDataSetChanged();
    }

    public void setAnnouncements(List<Announcement> announcementList) {
        setUpAnnouncements(announcementList, false);
        notifyDataSetChanged();
    }

    public void addAnnouncement(Announcement announcement) {
        mItems.add(0, new Item(announcement, null, ANNOUNCEMENT_VIEW));
        notifyItemInserted(0);
    }

    public class AnnouncementsListViewHolder extends RecyclerView.ViewHolder implements View.OnClickListener {

        FragmentActivity mActivity;
        Fragment mFragment;

        @Bind(R.id.announcement_user) TextView mUser;
        @Bind(R.id.announcement_time) TextView mTime;
        @Bind(R.id.announcement_title) TextView mTitle;
        @Bind(R.id.announcement_body) TextView mBody;
        @Bind(R.id.announcement_school) TextView mSchool;
        @Bind(R.id.announcement_profile_picture) CircleImageView mPicture;

        public AnnouncementsListViewHolder(View v, FragmentActivity activity, Fragment fragment) {
            super(v);
            mActivity = activity;
            mFragment = fragment;
            ButterKnife.bind(this, v);
        }

        @OnClick(R.id.announcement_row)
        public void onClick(View v) {
            Item item = mItems.get(getAdapterPosition());

            if (item.getType() == LOADING_VIEW) {
                return;
            }

            Intent intent = new Intent(mActivity, AnnouncementActivity.class);
            intent.putExtra("Announcement", announcementToString(item.getAnnouncement()));
            FragUtils.startActivityForResultFragment(mActivity, mFragment, AnnouncementActivity.class, FragUtils.SHOW_ANNOUNCEMENT_REQUEST_CODE, intent);
        }

        public String announcementToString(Announcement announcement) {
            ObjectMapper mapper = new ObjectMapper();
            String string = null;
            try {
                string = mapper.writeValueAsString(announcement);
            } catch (JsonProcessingException e) {
                Log.e(getClass().toString(), e.toString());
            }
            return string;
        }
    }

    @Data
    private static class Item {

        private Announcement announcement;
        private String header;
        private int type;

        public Item(Announcement announcement, String header, int type) {
            this.announcement = announcement;
            this.header = header;
            this.type = type;
        }
    }
}
