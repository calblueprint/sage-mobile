package blueprint.com.sage.joinSemester;

import android.os.Bundle;

import blueprint.com.sage.R;
import blueprint.com.sage.joinSemester.fragments.JoinSemesterFragment;
import blueprint.com.sage.shared.activities.BackAbstractActivity;
import blueprint.com.sage.utility.view.FragUtils;

/**
 * Created by charlesx on 1/30/16.
 */
public class JoinSemesterActivity extends BackAbstractActivity {

    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        FragUtils.replace(R.id.container, JoinSemesterFragment.newInstance(), this);
    }
}
