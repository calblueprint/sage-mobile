package blueprint.com.sage.announcements;

import android.view.MenuItem;
import android.view.View;

import blueprint.com.sage.R;
import blueprint.com.sage.events.announcements.EditAnnouncementEvent;
import blueprint.com.sage.models.Announcement;
import blueprint.com.sage.network.Requests;
import blueprint.com.sage.utility.view.FragUtils;

/**
 * Created by kelseylam on 1/7/16.
 */
public class EditAnnouncementFragment extends AnnouncementFormAbstractFragment {

    public static EditAnnouncementFragment newInstance(Announcement announcement) {
        EditAnnouncementFragment fragment = new EditAnnouncementFragment();
        fragment.setAnnouncement(announcement);
        return fragment;
    }

    @Override
    public boolean onOptionsItemSelected(MenuItem item) {
        switch (item.getItemId()) {
            case R.id.menu_save:
                validateAndSubmitRequest();
            default:
                return super.onOptionsItemSelected(item);
        }
    }

    public void setAnnouncement(Announcement announcement) { mAnnouncement = announcement; }

    public void initializeViews() {
        mToolbarInterface.setTitle("Edit Announcement");
        mAnnouncementTitle.setText(mAnnouncement.getTitle());
        mAnnouncementBody.setText(mAnnouncement.getBody());
        initializeSpinners();
        setSpinners();
    }

    public void setSpinners() {
        int category = mAnnouncement.getCategory();
        if (category == 0) {
            mAnnouncementCategory.setSelection(0);
            mAnnouncementSchoolList.setVisibility(View.VISIBLE);
        } else {
            mAnnouncementCategory.setSelection(1);
        }
    }

    protected void validateAndSubmitRequest() {
        if (!isValid())
            return;
        setAnnouncementCategoryAndSchool();
        mAnnouncement.setTitle(mAnnouncementTitle.getText().toString());
        mAnnouncement.setBody(mAnnouncementBody.getText().toString());
        Requests.Announcements.with(getActivity()).makeEditRequest(mAnnouncement);
    }

    public void onEvent(EditAnnouncementEvent event) {
        Announcement announcement = event.getMAnnouncement();
        AnnouncementInterface activity = (AnnouncementInterface) getActivity();
        activity.setAnnouncement(announcement);
        activity.setType(AnnouncementActivity.EDITED);
        FragUtils.popBackStack(this);
    }
}
