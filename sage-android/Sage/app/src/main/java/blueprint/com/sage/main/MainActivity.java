package blueprint.com.sage.main;

import android.os.Bundle;

import blueprint.com.sage.R;
import blueprint.com.sage.joinSemester.JoinSemesterActivity;
import blueprint.com.sage.main.fragments.MainFragment;
import blueprint.com.sage.shared.activities.AbstractActivity;
import blueprint.com.sage.shared.interfaces.ToolbarInterface;
import blueprint.com.sage.utility.model.SemesterUtils;
import blueprint.com.sage.utility.view.FragUtils;
import butterknife.ButterKnife;

/**
 * Created by charlesx on 12/23/15.
 * Main Activity launched when app opens.
 */
public class MainActivity extends AbstractActivity implements ToolbarInterface {

    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);
        ButterKnife.bind(this);
        FragUtils.replace(R.id.main_container, MainFragment.newInstance(), this);

        if (!SemesterUtils.isPartOfCurrentSemester(this)) {
            FragUtils.startActivityBackStack(this, JoinSemesterActivity.class);
        }
    }

    public void setToolbarElevation(float elevation) {}
}
