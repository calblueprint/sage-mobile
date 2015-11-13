package blueprint.com.sage.shared;

import android.content.Intent;
import android.os.Bundle;
import android.support.design.widget.NavigationView;
import android.support.v4.widget.DrawerLayout;
import android.support.v7.app.ActionBarDrawerToggle;
import android.support.v7.widget.Toolbar;
import android.util.Log;
import android.view.MenuItem;
import android.view.View;

import blueprint.com.sage.R;
import blueprint.com.sage.checkIn.CheckInListActivity;
import blueprint.com.sage.schools.SchoolsListActivity;
import blueprint.com.sage.utility.network.NetworkUtils;
import butterknife.Bind;
import butterknife.ButterKnife;

/**
 * Created by charlesx on 11/4/15.
 * Activity that basically adds a nav bar to your activity;
 */
public class NavigationAbstractActivity extends AbstractActivity
                                        implements NavigationView.OnNavigationItemSelectedListener {

    @Bind(R.id.drawer_layout) DrawerLayout mDrawerLayout;
    @Bind(R.id.left_drawer) NavigationView mNavigationView;
    @Bind(R.id.toolbar) Toolbar mToolbar;

    private ActionBarDrawerToggle mToggle;

    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_navigation);
        ButterKnife.bind(this);

        setSupportActionBar(mToolbar);
        initializeDrawer();
    }

    private void initializeDrawer() {
        mToggle =
                new ActionBarDrawerToggle(this, mDrawerLayout, mToolbar, R.string.open, R.string.close) {
                    @Override
                    public void onDrawerClosed(View drawerView) {
                        super.onDrawerClosed(drawerView);
                    }

                    @Override
                    public void onDrawerOpened(View drawerView) {
                        super.onDrawerOpened(drawerView);
                    }
                };
        mNavigationView.setNavigationItemSelectedListener(this);
        mDrawerLayout.setDrawerListener(mToggle);
        mToggle.syncState();
    }

    @Override
    public boolean onNavigationItemSelected(MenuItem item) {
        switch (item.getItemId()) {
            case R.id.announcements:
                Log.e("Selected announcements", "yay");
                break;
            case R.id.log_out:
                Log.e("Logging out", "yay");
                NetworkUtils.logoutCurrentUser(this);
                break;
            case R.id.schools:
                startSchoolsActivity();
                break;
            case R.id.requests:
                startRequestsActivity();
                break;
        }

        mDrawerLayout.closeDrawers();
        return true;
    }

    private void startSchoolsActivity() {
        if (this instanceof SchoolsListActivity) return;

        Intent intent = new Intent(this, SchoolsListActivity.class);
        intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK | Intent.FLAG_ACTIVITY_CLEAR_TASK);
        startActivity(intent);
    }

    private void startRequestsActivity() {
        if (this instanceof CheckInListActivity) return;

        Intent intent = new Intent(this, CheckInListActivity.class);
        intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK | Intent.FLAG_ACTIVITY_CLEAR_TASK);
        startActivity(intent);
    }
}
