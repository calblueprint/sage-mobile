package blueprint.com.sage.announcements;

import android.os.Bundle;

import blueprint.com.sage.R;
import blueprint.com.sage.shared.activities.BackAbstractActivity;
import blueprint.com.sage.utility.view.FragUtils;

/**
 * Created by kelseylam on 1/6/16.
 */
public class CreateAnnouncementActivity extends BackAbstractActivity {
    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        FragUtils.replace(R.id.container, CreateAnnouncementFragment.newInstance(), this);
    }
}
