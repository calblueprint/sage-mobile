package blueprint.com.sage.semester;

import android.os.Bundle;

import blueprint.com.sage.R;
import blueprint.com.sage.models.Semester;
import blueprint.com.sage.semester.fragments.CreateSemesterFragment;
import blueprint.com.sage.shared.activities.BackAbstractActivity;
import blueprint.com.sage.utility.view.FragUtils;

/**
 * Created by charlesx on 1/6/16.
 */
public class CreateSemesterActivity extends BackAbstractActivity {

    private Semester mSemester;

    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        FragUtils.replace(R.id.container, CreateSemesterFragment.newInstance(), this);
    }
}
