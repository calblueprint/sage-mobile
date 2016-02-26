package blueprint.com.sage.main;

import android.os.Bundle;

import blueprint.com.sage.R;
import blueprint.com.sage.main.fragments.AboutFragment;
import blueprint.com.sage.shared.activities.BackAbstractActivity;
import blueprint.com.sage.utility.view.FragUtils;

/**
 * Created by charlesx on 2/26/16.
 */
public class AboutActivity extends BackAbstractActivity {

    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        FragUtils.replace(R.id.container, AboutFragment.newInstance(), this);
    }
}
