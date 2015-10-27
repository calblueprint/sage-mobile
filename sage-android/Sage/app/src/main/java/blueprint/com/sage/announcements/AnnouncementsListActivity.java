package blueprint.com.sage.announcements;

import android.support.v4.app.FragmentTransaction;
import android.os.Bundle;
import android.support.v4.app.FragmentActivity;

import blueprint.com.sage.R;

/**
 * Created by kelseylam on 10/24/15.
 */
public class AnnouncementsListActivity extends FragmentActivity {
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_announcements);
        FragmentTransaction transaction = getSupportFragmentManager().beginTransaction();
        transaction.replace(R.id.announcements_container, AnnouncementsListFragment.newInstance()).commit();
    }
}
