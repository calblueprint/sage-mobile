package blueprint.com.sage.announcements;

import android.view.MenuItem;

import blueprint.com.sage.R;
import blueprint.com.sage.events.announcements.CreateAnnouncementEvent;
import blueprint.com.sage.models.Announcement;
import blueprint.com.sage.network.Requests;
import blueprint.com.sage.shared.interfaces.BaseInterface;
import blueprint.com.sage.utility.view.FragUtils;

/**
 * Created by kelseylam on 12/5/15.
 */
public class CreateAnnouncementFragment extends AnnouncementFormAbstractFragment {

    public static CreateAnnouncementFragment newInstance() { return new CreateAnnouncementFragment(); }

    @Override
    public boolean onOptionsItemSelected(MenuItem item) {
        switch (item.getItemId()) {
            case R.id.menu_save:
                if (validateAndSubmitRequest()) getActivity().onBackPressed();
            default:
                return super.onOptionsItemSelected(item);
        }
    }

    public void initializeViews() {
        getActivity().setTitle("Create Announcement");
        mAnnouncement = new Announcement();
        initializeSpinners();
    }

    protected boolean validateAndSubmitRequest() {
        setAnnouncement();
        if (!isValid())
            return false;
        mAnnouncement.setTitle(mAnnouncementTitle.getText().toString());
        mAnnouncement.setBody(mAnnouncementBody.getText().toString());
        BaseInterface baseInterface = (BaseInterface) getActivity();
        mAnnouncement.setUserId(baseInterface.getUser().getId());
        Requests.Announcements.with(getActivity()).makeCreateRequest(mAnnouncement);
        return true;
    }

    public void onEvent(CreateAnnouncementEvent event) {
        FragUtils.popBackStack(this);
    }
}
