package blueprint.com.sage.shared;

import android.os.Bundle;
import android.support.design.widget.NavigationView;
import android.support.v4.widget.DrawerLayout;
import android.support.v7.app.ActionBarDrawerToggle;
import android.support.v7.widget.Toolbar;
import android.util.Log;
import android.view.MenuItem;
import android.view.View;

import blueprint.com.sage.R;
import blueprint.com.sage.utility.network.NetworkUtils;
import butterknife.Bind;
import butterknife.ButterKnife;

/**
 * Created by charlesx on 11/4/15.
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
        }

        mDrawerLayout.closeDrawers();
        return true;
    }

}
