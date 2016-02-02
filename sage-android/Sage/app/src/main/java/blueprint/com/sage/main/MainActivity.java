package blueprint.com.sage.main;

import android.os.Bundle;
import android.support.v7.widget.Toolbar;

import blueprint.com.sage.R;
import blueprint.com.sage.main.fragments.MainFragment;
import blueprint.com.sage.shared.activities.AbstractActivity;
import blueprint.com.sage.shared.interfaces.ToolbarInterface;
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
    }

    public void setToolbarElevation(float elevation) {}
    public void showToolbar(Toolbar toolbar) {}
    public void hideToolbar(Toolbar toolbar) {}
}
