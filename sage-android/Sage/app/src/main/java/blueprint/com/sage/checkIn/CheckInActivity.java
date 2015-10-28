package blueprint.com.sage.checkIn;

import android.os.Bundle;
import android.support.design.widget.NavigationView;
import android.support.v4.widget.DrawerLayout;
import android.support.v7.app.ActionBarDrawerToggle;
import android.support.v7.widget.Toolbar;
import android.util.Log;
import android.view.Menu;
import android.view.MenuItem;
import android.view.View;

import com.google.android.gms.common.api.GoogleApiClient;
import com.google.android.gms.location.LocationServices;

import blueprint.com.sage.R;
import blueprint.com.sage.checkIn.fragments.CheckInMapFragment;
import blueprint.com.sage.shared.AbstractActivity;
import blueprint.com.sage.utility.network.NetworkUtils;
import blueprint.com.sage.utility.view.FragUtil;
import butterknife.Bind;
import butterknife.ButterKnife;

/**
 * Created by charlesx on 10/16/15.
 * Check in Activity
 */
public class CheckInActivity extends AbstractActivity
                             implements NavigationView.OnNavigationItemSelectedListener {

    @Bind(R.id.check_in_drawer_layout) DrawerLayout mDrawerLayout;
    @Bind(R.id.check_in_left_drawer) NavigationView mNavigationView;
    @Bind(R.id.check_in_toolbar) Toolbar mToolbar;

    private ActionBarDrawerToggle mToggle;

    private GoogleApiClient mGoogleApiClient;

    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

        setContentView(R.layout.activity_check_in);
        ButterKnife.bind(this);
        setSupportActionBar(mToolbar);

        initializeGoogleApiClient();
        initializeDrawer();

        FragUtil.replace(R.id.check_in_container, CheckInMapFragment.newInstance(), this);
    }

    @Override
    public void onStart() {
        super.onStart();
        if (mGoogleApiClient != null)
            mGoogleApiClient.connect();
    }

    @Override
    public void onStop() {
        super.onStop();
        if (mGoogleApiClient != null && mGoogleApiClient.isConnected())
            mGoogleApiClient.disconnect();
    }

    protected synchronized void initializeGoogleApiClient() {
        mGoogleApiClient = new GoogleApiClient.Builder(this)
                                              .addApi(LocationServices.API)
                                              .build();
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

    public GoogleApiClient getClient() { return mGoogleApiClient; }
}
