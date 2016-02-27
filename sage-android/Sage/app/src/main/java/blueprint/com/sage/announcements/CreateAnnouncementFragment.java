package blueprint.com.sage.announcements;

import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;
import android.view.MenuItem;

import blueprint.com.sage.R;
import blueprint.com.sage.events.announcements.CreateAnnouncementEvent;
import blueprint.com.sage.models.Announcement;
import blueprint.com.sage.network.Requests;
import blueprint.com.sage.shared.interfaces.BaseInterface;
import blueprint.com.sage.utility.network.NetworkUtils;

/**
 * Created by kelseylam on 12/5/15.
 */
public class CreateAnnouncementFragment extends AnnouncementFormAbstractFragment {

    public static CreateAnnouncementFragment newInstance() { return new CreateAnnouncementFragment(); }

    @Override
    public boolean onOptionsItemSelected(MenuItem item) {
        mItem = item;
        switch (item.getItemId()) {
            case R.id.menu_save:
                validateAndSubmitRequest();
            default:
                return super.onOptionsItemSelected(item);
        }
    }

    public void initializeViews() {
        mToolbarInterface.setTitle("Create Announcement");
        mAnnouncement = new Announcement();
        initializeSpinners();
    }

    protected void validateAndSubmitRequest() {
        if (!isValid())
            return;
        setAnnouncementCategoryAndSchool();
        mAnnouncement.setTitle(mAnnouncementTitle.getText().toString());
        mAnnouncement.setBody(mAnnouncementBody.getText().toString());
        BaseInterface baseInterface = (BaseInterface) getActivity();
        mAnnouncement.setUserId(baseInterface.getUser().getId());

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

        mItem.setActionView(null);

        getActivity().setResult(Activity.RESULT_OK, intent);
        getActivity().onBackPressed();
    }
}
