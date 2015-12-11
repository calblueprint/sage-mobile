package blueprint.com.sage.announcements;

import android.os.Bundle;
import android.support.v4.app.Fragment;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.TextView;

import blueprint.com.sage.R;
import blueprint.com.sage.models.Announcement;
import blueprint.com.sage.models.User;
import blueprint.com.sage.shared.views.CircleImageView;
import butterknife.Bind;
import butterknife.ButterKnife;

/**
 * Created by kelseylam on 11/4/15.
 */
public class AnnouncementFragment extends Fragment {

    Announcement announcement;

    @Bind(R.id.announcement_user_single) TextView vUser;
    @Bind(R.id.announcement_time_single) TextView vTime;
    @Bind(R.id.announcement_title_single) TextView vTitle;
    @Bind(R.id.announcement_body_single) TextView vBody;
    @Bind(R.id.announcement_pf_pic_single) CircleImageView vPicture;

    public static AnnouncementFragment newInstance(Announcement announcement) {
        AnnouncementFragment fragment = new AnnouncementFragment();
        fragment.setAnnouncement(announcement);
        return fragment;
    }

    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
    }

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
        super.onCreateView(inflater, container, savedInstanceState);
        View view = inflater.inflate(R.layout.fragment_announcement, container, false);
        ButterKnife.bind(this, view);
        initializeViews();
        return view;
    }

    public void initializeViews() {
        User user = announcement.getUser();
        if (user != null) {
            vUser.setText(user.getName());
        }
        vTime.setText(announcement.getDate());
        vTitle.setText(announcement.getTitle());
        vBody.setText(announcement.getBody());
        user.loadUserImage(getActivity(), vPicture);
    }

    public void setAnnouncement(Announcement announcement) {
        this.announcement = announcement;
    }
}
