package blueprint.com.sage.admin.semester.fragments;

import android.content.Intent;
import android.os.Bundle;
import android.support.v4.app.Fragment;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.Button;
import android.widget.FrameLayout;
import android.widget.LinearLayout;
import android.widget.TextView;

import blueprint.com.sage.R;
import blueprint.com.sage.announcements.CreateAnnouncementActivity;
import blueprint.com.sage.models.Semester;
import blueprint.com.sage.models.User;
import blueprint.com.sage.shared.interfaces.BaseInterface;
import blueprint.com.sage.shared.views.CircleImageView;
import blueprint.com.sage.utility.view.FragUtils;
import butterknife.Bind;
import butterknife.ButterKnife;
import butterknife.OnClick;

/**
 * Created by kelseylam on 8/15/16.
 */
public class FinishPauseSemesterFragment extends Fragment {

    @Bind(R.id.pause_semester_announcement) LinearLayout mAnnouncement;
    @Bind(R.id.pause_semester_confirm_announcement) Button mConfirmButton;
    @Bind(R.id.pause_semester_announcement_loading) FrameLayout mLoadingIndicator;
    @Bind(R.id.announcement_user) TextView mUser;
    @Bind(R.id.announcement_time) TextView mTime;
    @Bind(R.id.announcement_title) TextView mTitle;
    @Bind(R.id.announcement_body) TextView mBody;
    @Bind(R.id.announcement_school) TextView mSchool;
    @Bind(R.id.announcement_profile_picture) CircleImageView mPicture;

    private BaseInterface mBaseInterface;
    private Semester mSemester;

    public static FinishPauseSemesterFragment newInstance() {
        return new FinishPauseSemesterFragment();
    }

    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        mBaseInterface = (BaseInterface) getActivity();
    }

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup parent, Bundle savedInstanceState) {
        super.onCreateView(inflater, parent, savedInstanceState);
        View view = inflater.inflate(R.layout.fragment_finish_pause_semester, parent, false);
        ButterKnife.bind(this, view);
        initializeAnnouncementView();
        return view;
    }

    private void initializeAnnouncementView() {
        User user = mBaseInterface.getUser();

        if (user == null) {
            Log.e("User Null", "Base Interface user is null");
            return;
        }

        mUser.setText(user.getName());
        user.loadUserImage(getActivity(), mPicture);

        mTime.setText(getString(R.string.pause_semester_today));
        mTitle.setText(getString(R.string.pause_semester_announcement_title));
        mBody.setText(getString(R.string.pause_semester_announcement_body));

        mSchool.setVisibility(View.GONE);
    }

    @OnClick(R.id.pause_semester_confirm_announcement)
    public void onCreateAnnouncement(View view) {
        mLoadingIndicator.setVisibility(View.VISIBLE);
        mConfirmButton.setVisibility(View.INVISIBLE);

        Intent announcementIntent = new Intent(getActivity(), CreateAnnouncementActivity.class);
        announcementIntent.putExtra(getString(R.string.pause_semester_announcement_string), getString(R.string.pause_semester_announcement_title));
        FragUtils.startActivityForResultFragment(getActivity(), this, CreateAnnouncementActivity.class, FragUtils.CREATE_ANNOUNCEMENT_REQUEST_CODE, announcementIntent);
        getActivity().onBackPressed();
    }


    @OnClick(R.id.pause_semester_cancel_announcement)
    public void onCancelCreateAnnouncement(View view) {
        getActivity().onBackPressed();
    }}
