package blueprint.com.sage.announcements;

import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;

import blueprint.com.sage.R;
import blueprint.com.sage.events.announcements.CreateAnnouncementEvent;
import blueprint.com.sage.models.Announcement;
import blueprint.com.sage.network.Requests;
import blueprint.com.sage.utility.network.NetworkUtils;

/**
 * Created by kelseylam on 12/5/15.
 */
public class CreateAnnouncementFragment extends AnnouncementFormAbstractFragment {

    public static CreateAnnouncementFragment newInstance() { return new CreateAnnouncementFragment(); }

    public void initializeViews() {
        mToolbarInterface.setTitle("Create Announcement");
        mAnnouncement = new Announcement();
        initializeSpinners();

        Intent intent = getActivity().getIntent();
        String title = intent.getStringExtra(getString(R.string.pause_semester_announcement_string, ""));
        mAnnouncementTitle.setText(title);
    }

    protected void validateAndSubmitRequest() {
        if (!isValid())
            return;

        setAnnouncementCategoryAndSchool();

        mAnnouncement.setTitle(mAnnouncementTitle.getText().toString());
        mAnnouncement.setBody(mAnnouncementBody.getText().toString());

        mAnnouncement.setUserId(mBaseInterface.getUser().getId());
        mItem.setActionView(R.layout.actionbar_indeterminate_progress);
        Requests.Announcements.with(getActivity()).makeCreateRequest(mAnnouncement);
    }

    public void onEvent(CreateAnnouncementEvent event) {
        Announcement announcement = event.getMAnnouncement();
        Intent intent = new Intent();
        Bundle bundle = new Bundle();
        bundle.putString(getString(R.string.create_announcement),
                NetworkUtils.writeAsString(getActivity(), announcement));
        intent.putExtras(bundle);
        getActivity().setResult(Activity.RESULT_OK, intent);
        getActivity().onBackPressed();
    }
}
