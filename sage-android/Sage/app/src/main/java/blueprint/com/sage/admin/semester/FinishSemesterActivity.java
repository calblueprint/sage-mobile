package blueprint.com.sage.admin.semester;

import android.os.Bundle;

import blueprint.com.sage.R;
import blueprint.com.sage.admin.semester.fragments.FinishSemesterFragment;
import blueprint.com.sage.shared.activities.BackAbstractActivity;
import blueprint.com.sage.utility.view.FragUtils;

/**
 * Created by charlesx on 1/7/16.
 */
public class FinishSemesterActivity extends BackAbstractActivity {

    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        FragUtils.replace(R.id.container, FinishSemesterFragment.newInstance(), this);
    }
}
