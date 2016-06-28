package blueprint.com.sage.admin.semester;

import android.os.Bundle;

import blueprint.com.sage.R;
import blueprint.com.sage.admin.semester.fragments.PauseSemesterFragment;
import blueprint.com.sage.shared.activities.BackAbstractActivity;
import blueprint.com.sage.utility.view.FragUtils;

/**
 * Created by kelseylam on 6/25/16.
 */
public class PauseSemesterActivity extends BackAbstractActivity {
    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        FragUtils.replace(R.id.container, PauseSemesterFragment.newInstance(), this);
    }
}
