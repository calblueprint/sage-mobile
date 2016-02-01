package blueprint.com.sage.announcements.adapters;

import android.content.Intent;
import android.support.v4.app.Fragment;
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
import blueprint.com.sage.utility.view.FragUtils;
import butterknife.Bind;
import butterknife.ButterKnife;
import butterknife.OnClick;

/**
 * Created by kelseylam on 10/24/15.
 */
public class AnnouncementsListAdapter extends RecyclerView.Adapter<AnnouncementsListAdapter.AnnouncementsListViewHolder> {

    private static ArrayList<Announcement> mAnnouncementArrayList;
    private FragmentActivity mActivity;
    private Fragment mFragment;

    public AnnouncementsListAdapter(ArrayList<Announcement> announcementArrayList, FragmentActivity activity, Fragment fragment) {
        mAnnouncementArrayList = announcementArrayList;
        mActivity = activity;
        mFragment = fragment;
    }

    @Override
    public int getItemCount() {
        return mAnnouncementArrayList.size();
    }

    @Override
    public void onBindViewHolder(AnnouncementsListViewHolder viewHolder, int i) {
        Announcement announcement = mAnnouncementArrayList.get(i);
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
    public AnnouncementsListViewHolder onCreateViewHolder(ViewGroup viewGroup, int i) {
        View view = LayoutInflater.from(viewGroup.getContext()).inflate(R.layout.announcement_row, viewGroup, false);
        return new AnnouncementsListViewHolder(view, mActivity, mFragment);
    }

    public void setAnnouncements(ArrayList<Announcement> curList) {
        mAnnouncementArrayList = curList;
        notifyDataSetChanged();
    }

    public static class AnnouncementsListViewHolder extends RecyclerView.ViewHolder implements View.OnClickListener {

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
            Announcement announcement = mAnnouncementArrayList.get(getAdapterPosition());
            Intent intent = new Intent(mActivity, AnnouncementActivity.class);
            intent.putExtra("Announcement", announcementToString(announcement));
            FragUtils.startActivityForResultFragment(mActivity, mFragment, AnnouncementActivity.class, FragUtils.SHOW_ANNOUNCEMENT_REQUEST_CODE, intent);
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
