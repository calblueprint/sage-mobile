package blueprint.com.sage.check_in;

import android.os.Bundle;
import android.support.design.widget.NavigationView;
import android.support.v4.widget.DrawerLayout;
import android.support.v7.app.ActionBarDrawerToggle;
import android.support.v7.app.AppCompatActivity;
import android.support.v7.widget.Toolbar;
import android.util.Log;
import android.view.Menu;
import android.view.MenuItem;
import android.view.View;

import blueprint.com.sage.R;
import blueprint.com.sage.check_in.fragments.CheckInMapFragment;
import blueprint.com.sage.utility.view.FragUtil;
import butterknife.Bind;
import butterknife.ButterKnife;

/**
 * Created by charlesx on 10/16/15.
 * Check in Activity
 */
public class CheckInActivity extends AppCompatActivity
                             implements NavigationView.OnNavigationItemSelectedListener {

    @Bind(R.id.check_in_drawer_layout) DrawerLayout mDrawerLayout;
    @Bind(R.id.check_in_left_drawer) NavigationView mNavigationView;
    @Bind(R.id.check_in_toolbar) Toolbar mToolbar;

    private ActionBarDrawerToggle mToggle;

    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_check_in);
        ButterKnife.bind(this);
        setSupportActionBar(mToolbar);

        initializeDrawer();
        FragUtil.replace(R.id.check_in_container, CheckInMapFragment.newInstance(), this);
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
        mDrawerLayout.setDrawerListener(mToggle);
        mToggle.syncState();
    }

    @Override
    public boolean onNavigationItemSelected(MenuItem item) {
        switch (item.getItemId()) {
            case R.id.announcements:
                item.setChecked(true);
                Log.e("Selected announcements", "yay");
                break;
        }

        mDrawerLayout.closeDrawers();
        return true;
    }

    @Override
    public boolean onCreateOptionsMenu(Menu menu) {
        getMenuInflater().inflate(R.menu.menu_check_in, menu);
        return true;
    }

    @Override
    public boolean onOptionsItemSelected(MenuItem item) {
        switch (item.getItemId()) {
            case R.id.menu_request:
                break;
        }
        return super.onOptionsItemSelected(item);
    }
}
