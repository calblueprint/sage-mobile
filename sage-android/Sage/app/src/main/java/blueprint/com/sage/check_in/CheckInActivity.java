package blueprint.com.sage.check_in;

import android.os.Bundle;
import android.support.v4.app.FragmentActivity;
import android.widget.LinearLayout;

import blueprint.com.sage.R;
import blueprint.com.sage.check_in.fragments.CheckInMapFragment;
import blueprint.com.sage.utility.view.FragUtil;
import butterknife.Bind;
import butterknife.ButterKnife;

/**
 * Created by charlesx on 10/16/15.
 */
public class CheckInActivity extends FragmentActivity {

    @Bind(R.id.check_in_left_drawer) LinearLayout mDrawer;


    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_check_in);
        ButterKnife.bind(this);

        initializeDrawer();
        FragUtil.replace(R.id.check_in_container, CheckInMapFragment.newInstance(), this);
    }

    private void initializeDrawer() {

    }
}
