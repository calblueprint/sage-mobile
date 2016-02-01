package blueprint.com.sage.announcements;

import android.content.DialogInterface;
import android.os.Bundle;
import android.support.v4.app.Fragment;
import android.support.v7.app.AlertDialog;
import android.view.LayoutInflater;
import android.view.Menu;
import android.view.MenuInflater;
import android.view.MenuItem;
import android.view.View;
import android.view.ViewGroup;
import android.widget.TextView;

import blueprint.com.sage.R;
import blueprint.com.sage.events.announcements.AnnouncementEvent;
import blueprint.com.sage.events.announcements.DeleteAnnouncementEvent;
import blueprint.com.sage.models.Announcement;
import blueprint.com.sage.models.User;
import blueprint.com.sage.network.Requests;
import blueprint.com.sage.shared.interfaces.BaseInterface;
import blueprint.com.sage.shared.views.CircleImageView;
import blueprint.com.sage.utility.view.FragUtils;
import butterknife.Bind;
import butterknife.ButterKnife;
import de.greenrobot.event.EventBus;

/**
 * Created by kelseylam on 11/4/15.
 */
public class AnnouncementFragment extends Fragment {

    private Announcement mAnnouncement;
    private BaseInterface mBaseInterface;

    @Bind(R.id.announcement_user_single) TextView mUser;
    @Bind(R.id.announcement_school_single) TextView mSchool;
    @Bind(R.id.announcement_time_single) TextView mTime;
    @Bind(R.id.announcement_title_single) TextView mTitle;
    @Bind(R.id.announcement_body_single) TextView mBody;
    @Bind(R.id.announcement_pf_pic_single) CircleImageView mPicture;

    public static AnnouncementFragment newInstance(Announcement announcement) {
        AnnouncementFragment fragment = new AnnouncementFragment();
        fragment.setAnnouncement(announcement);
        return fragment;
    }

    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        mBaseInterface = (BaseInterface) getActivity();
        if (mBaseInterface.getUser().isAdmin() && mBaseInterface.getUser().getId() == mAnnouncement.getUser().getId()) {
            setHasOptionsMenu(true);
        }
    }

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
        super.onCreateView(inflater, container, savedInstanceState);
        View view = inflater.inflate(R.layout.fragment_announcement, container, false);
        ButterKnife.bind(this, view);
        initializeViews();
        initializeAnnouncement();
        return view;
    }

    @Override
    public void onCreateOptionsMenu(Menu menu, MenuInflater inflater) {
        menu.clear();
        inflater.inflate(R.menu.menu_edit_delete, menu);
        super.onCreateOptionsMenu(menu, inflater);
    }

    @Override
    public boolean onOptionsItemSelected(MenuItem item) {
        switch (item.getItemId()) {
            case R.id.menu_edit:
                FragUtils.replaceBackStack(R.id.container, EditAnnouncementFragment.newInstance(mAnnouncement), getActivity());
                break;
            case R.id.menu_delete:
                confirmDelete();
                break;
        }
        return super.onOptionsItemSelected(item);

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

    public void confirmDelete() {
        AlertDialog.Builder builder = new AlertDialog.Builder(getActivity());
        builder.setMessage(R.string.confirm_delete);
        builder.setCancelable(true);
        builder.setPositiveButton(
                R.string.announcement_yes,
                new DialogInterface.OnClickListener() {
                    public void onClick(DialogInterface dialog, int id) {
                        Requests.Announcements.with(getActivity()).makeDeleteRequest(mAnnouncement);
                    }
                });

        builder.setNegativeButton(
                R.string.announcement_no,
                new DialogInterface.OnClickListener() {
                    public void onClick(DialogInterface dialog, int id) {
                        dialog.dismiss();
                    }
                });

        AlertDialog alert = builder.create();
        alert.show();
    }

    public void initializeViews() {
        getActivity().setTitle("Announcement");
        Requests.Announcements.with(getActivity()).makeShowRequest(mAnnouncement);
    }

    public void initializeAnnouncement() {
        User user = mAnnouncement.getUser();
        user.loadUserImage(getActivity(), mPicture);
        mUser.setText(user.getName());
        if (mAnnouncement.getSchool() != null) {
            mSchool.setVisibility(View.VISIBLE);
            mSchool.setText(mAnnouncement.getSchool().getName());
        } else {
            mSchool.setVisibility(View.GONE);
        }
        mTime.setText(mAnnouncement.getDate());
        mTitle.setText(mAnnouncement.getTitle());
        mBody.setText(mAnnouncement.getBody());
    }

    public void setAnnouncement(Announcement announcement) {
        mAnnouncement = announcement;
    }

    public void onEvent(AnnouncementEvent event) {
        mAnnouncement = event.getMAnnouncement();
        initializeAnnouncement();
    }

    public void onEvent(DeleteAnnouncementEvent event) {
        Announcement announcement = event.getMAnnouncement();
        AnnouncementInterface activity = (AnnouncementInterface) getActivity();
        activity.setAnnouncement(announcement);
        activity.setType(AnnouncementActivity.DELETED);
        getActivity().onBackPressed();
    }

}
