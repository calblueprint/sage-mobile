package blueprint.com.sage.main;

import android.os.Bundle;

import blueprint.com.sage.R;
import blueprint.com.sage.main.fragments.MainFragment;
import blueprint.com.sage.shared.activities.AbstractActivity;
import blueprint.com.sage.utility.view.FragUtils;
import butterknife.ButterKnife;

/**
 * Created by charlesx on 12/23/15.
 * Main Activity launched when app opens.
 */
public class MainActivity extends AbstractActivity{

    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);
        ButterKnife.bind(this);
        FragUtils.replace(R.id.main_container, MainFragment.newInstance(), this);
    }
}
